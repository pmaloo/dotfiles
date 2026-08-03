# Midway Automation

Automated Midway credential refresh — YubiKey tap only, no PIN typing. Fires on wake, available manually via `mw`, syncs cookie to Cloud Desktops.

## Prerequisites

- YubiKey enrolled with Midway
- FIDO2 PIN stored in macOS Keychain:
  ```bash
  security add-generic-password -s "mwinit" -a "$USER" -w "YOUR_FIDO2_PIN" -U
  ```
- SSH config with `clouddesk` and `devdesk` aliases
- `brew install sleepwatcher && brew services start sleepwatcher`

## Components

| Component | Location | Purpose |
|---|---|---|
| `mwinit-auto.sh` | `~/.local/bin/` | Headless cert check → PIN from Keychain → mwinit → sync |
| `.wakeup` | `~/` | sleepwatcher hook, calls mwinit-auto.sh on lid-open |
| `mwinit-auto` plist | `~/Library/LaunchAgents/` | Every 15 min + login safety net |
| `midway-sync` plist | `~/Library/LaunchAgents/` | WatchPaths cookie → scp to cloud desktops |
| `mw` function | `~/.work` | Manual trigger: PIN → mwinit → sync |

## How It Works

| Trigger | Flow |
|---|---|
| Lid open / wake | sleepwatcher → `.wakeup` → `mwinit-auto.sh` → PIN from Keychain → tap YubiKey → sync cookie |
| Manual `mw` | PIN from Keychain → tap YubiKey → sync cookie |
| Any mwinit (fallback) | `midway-sync` LaunchAgent detects cookie change → syncs |

## Setup

### 1. mwinit-auto.sh

```bash
#!/bin/bash
THRESHOLD_HOURS=${THRESHOLD_HOURS:-4}
CERT_FILE="$HOME/.ssh/id_ecdsa-cert.pub"
LOG_TAG="mwinit-auto"

log() { logger -t "$LOG_TAG" "$1"; }

if [ ! -f "$CERT_FILE" ]; then
    NEEDS_REFRESH=true; REMAINING=0
else
    EXPIRY=$(ssh-keygen -L -f "$CERT_FILE" 2>/dev/null | grep "Valid:" | sed 's/.*to //')
    if [ -z "$EXPIRY" ]; then
        NEEDS_REFRESH=true; REMAINING=0
    else
        EXPIRY_EPOCH=$(date -j -f "%Y-%m-%dT%H:%M:%S" "$EXPIRY" "+%s" 2>/dev/null)
        NOW_EPOCH=$(date "+%s")
        REMAINING=$(( (EXPIRY_EPOCH - NOW_EPOCH) / 3600 ))
        [ "$REMAINING" -lt "$THRESHOLD_HOURS" ] && NEEDS_REFRESH=true || exit 0
    fi
fi

PIN=$(security find-generic-password -s "mwinit" -a "$USER" -w 2>/dev/null)

if [ -n "$PIN" ]; then
    osascript -e "display notification \"Midway expires in ${REMAINING}h — tap YubiKey\" with title \"Midway Refresh\""
    if echo "$PIN" | mwinit -f -s; then
        kinit -f 2>/dev/null || true
        log "Refreshed successfully (was ${REMAINING}h remaining)"
        osascript -e "display notification \"Midway refreshed\" with title \"Midway\""
        scp ~/.midway/cookie clouddesk:~/.midway/cookie 2>/dev/null &
        scp ~/.midway/cookie devdesk:~/.midway/cookie 2>/dev/null &
    else
        log "mwinit failed"; osascript -e "display notification \"mwinit failed — run mw manually\" with title \"Midway Error\""
    fi
else
    log "No PIN in Keychain"; osascript -e "display notification \"Run mw manually\" with title \"Midway Error\""
fi
```

### 2. ~/.wakeup

```bash
#!/bin/bash
sleep 3
~/.local/bin/mwinit-auto.sh
```

### 3. mw function (in ~/.work)

```bash
mw() {
    local pin
    pin=$(security find-generic-password -s "mwinit" -a "$USER" -w 2>/dev/null)
    if [ -n "$pin" ]; then
        echo "$pin" | mwinit -f -s
    else
        echo "No PIN in Keychain — running interactive mwinit"
        mwinit -o
    fi
    scp ~/.midway/cookie clouddesk:~/.midway/cookie 2>/dev/null &
    scp ~/.midway/cookie devdesk:~/.midway/cookie 2>/dev/null &
}
```

### 4. LaunchAgents

**mwinit-auto** (every 15 min + login):
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key><string>com.pmaloo.mwinit-auto</string>
    <key>ProgramArguments</key><array><string>/Users/pmaloo/.local/bin/mwinit-auto.sh</string></array>
    <key>RunAtLoad</key><true/>
    <key>StartInterval</key><integer>900</integer>
    <key>StandardOutPath</key><string>/tmp/mwinit-auto.log</string>
    <key>StandardErrorPath</key><string>/tmp/mwinit-auto.err</string>
</dict>
</plist>
```

**midway-sync** (on cookie change):
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key><string>com.pmaloo.midway-sync</string>
    <key>EnvironmentVariables</key><dict><key>PATH</key><string>/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin</string></dict>
    <key>ProgramArguments</key><array>
        <string>/bin/bash</string><string>-c</string>
        <string>scp ~/.midway/cookie clouddesk:~/.midway/cookie 2>/dev/null; scp ~/.midway/cookie devdesk:~/.midway/cookie 2>/dev/null</string>
    </array>
    <key>WatchPaths</key><array><string>/Users/pmaloo/.midway/cookie</string></array>
    <key>StandardOutPath</key><string>/tmp/midway-sync.log</string>
    <key>StandardErrorPath</key><string>/tmp/midway-sync.err</string>
</dict>
</plist>
```

## Troubleshooting

- Logs: `/tmp/mwinit-auto.log`, `/tmp/mwinit-auto.err`
- System log: `log show --predicate 'eventMessage contains "mwinit-auto"' --last 1h`
- Verify sleepwatcher: `launchctl list | grep sleepwatcher`
- Verify PIN: `security find-generic-password -s "mwinit" -a "$USER" -w`
- Pre-auth sudo for brew installs: `sudo -v` (caches for ~5 min)
