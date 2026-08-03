# MeshClaw Setup

MeshClaw AI agent gateway — runs on Cloud Desktop, accessed from laptop via SSH tunnel.

## Cloud Desktop (gateway + tunnel service)

### Install

```bash
toolbox registry add s3://buildertoolbox-meshclaw-us-west-2/tools.json
toolbox registry add s3://tunnels-toolbox-prod/tools.json
toolbox install meshclaw tunnels
```

### Systemd services

**Gateway:**
```bash
sudo tee /etc/systemd/system/meshclaw.service > /dev/null << 'EOF'
[Unit]
Description=MeshClaw AI Agent Gateway
After=network-online.target

[Service]
Type=simple
User=pmaloo
ExecStart=/home/pmaloo/.toolbox/bin/meshclaw gateway
Restart=always
RestartSec=10
WorkingDirectory=/home/pmaloo
Environment=HOME=/home/pmaloo
Environment=PATH=/home/pmaloo/.toolbox/bin:/usr/local/bin:/usr/bin

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload && sudo systemctl enable --now meshclaw
```

**Tunnel:**
```bash
sudo tee /etc/systemd/system/meshclaw-tunnel.service > /dev/null << 'EOF'
[Unit]
Description=MeshClaw Tunnel
After=meshclaw.service
BindsTo=meshclaw.service

[Service]
Type=simple
User=pmaloo
ExecStart=/home/pmaloo/.toolbox/bin/tunnel create 7777 --name meshclaw
Restart=always
RestartSec=5
Environment=HOME=/home/pmaloo

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload && sudo systemctl enable --now meshclaw-tunnel
```

### AEA cookie auto-refresh

Prevents MCP tools from breaking. Refreshes silently every 90 min (no YubiKey needed — uses session cookie):

```bash
(crontab -l 2>/dev/null; echo '*/90 * * * * /usr/bin/mwinit --refresh-aea >/dev/null 2>&1') | crontab -
```

One `mwinit -o` in the morning → ~20h of uninterrupted auth.

## Laptop (SSH tunnel + token)

### SSH config

```
Host clouddesk
    HostName <your-cloud-desktop-hostname>
    User <your-alias>
    ForwardAgent yes
    ServerAliveInterval 15
    ServerAliveCountMax 3
    ProxyCommand /usr/local/bin/wssh proxy %h
```

### Persistent tunnel (LaunchAgent)

`~/Library/LaunchAgents/com.pmaloo.meshclaw-tunnel.plist` — uses autossh to keep ports 7777 + 8888 forwarded:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key><string>com.pmaloo.meshclaw-tunnel</string>
    <key>ProgramArguments</key>
    <array>
        <string>/opt/homebrew/bin/autossh</string>
        <string>-M</string><string>20000</string>
        <string>-N</string>
        <string>-o</string><string>ServerAliveInterval=15</string>
        <string>-o</string><string>ServerAliveCountMax=3</string>
        <string>-o</string><string>ExitOnForwardFailure=yes</string>
        <string>-L</string><string>7777:localhost:7777</string>
        <string>-L</string><string>8888:localhost:8888</string>
        <string>clouddesk</string>
    </array>
    <key>RunAtLoad</key><true/>
    <key>KeepAlive</key><true/>
    <key>StandardOutPath</key><string>/tmp/meshclaw-tunnel.log</string>
    <key>StandardErrorPath</key><string>/tmp/meshclaw-tunnel.err</string>
</dict>
</plist>
```

Load: `launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.pmaloo.meshclaw-tunnel.plist`

### Token refresh + bookmark

```bash
# ~/bin/meshclaw-refresh
#!/bin/bash
TOKEN_URL="$(ssh clouddesk "PATH=\$HOME/.toolbox/bin:\$PATH meshclaw token 2>/dev/null | head -1")"
if [ -n "$TOKEN_URL" ]; then
  echo '<meta http-equiv="refresh" content="0;url='"$TOKEN_URL"'"><a href="'"$TOKEN_URL"'">MeshClaw</a>' > ~/.meshclaw.html
  echo "Token refreshed"
fi
```

Cron refreshes every 30 min. Bookmark `file:///Users/$USER/.meshclaw.html`.

### Alternative: CloudMesh app

One-click native macOS app (Spotlight: "CloudMesh"). Handles tunnel + token + dashboard automatically. Install from internal package repo.

## Daily Workflow

1. **Morning:** `mw` on laptop (refreshes Midway + syncs cookie to cloud desktop)
2. **All day:** AEA auto-refreshes, tunnel stays up, bookmark works
3. **Access:** `http://localhost:7777` or `.meshclaw.html` bookmark

## Troubleshooting

| Symptom | Fix |
|---|---|
| Port 7777 not listening | `/bin/cat /tmp/meshclaw-tunnel.err`. Restart: `launchctl kickstart -k gui/$(id -u)/com.pmaloo.meshclaw-tunnel` |
| "Session expired" in browser | `~/bin/meshclaw-refresh && open ~/.meshclaw.html` |
| MCP tools failing | `mwinit -o` on cloud desktop (session cookie expired) |
| Tunnel connects but token empty | `ssh clouddesk "sudo systemctl restart meshclaw"` |
