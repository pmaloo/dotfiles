#!/usr/bin/env bash
# meshclaw-catchup.sh — re-run meshclaw cron jobs that failed (e.g. overnight
# Bedrock/ada "security token expired" 403) once AWS creds are valid again.
#
# meshclaw has no native missed-run catch-up for cron-expr jobs: a failed run is
# dropped until the next scheduled occurrence. This closes that gap. Run it on a
# short interval (crontab */15); it self-guards so it only acts when creds work
# AND a job is in error, and each successful re-run flips last_status→ok so it
# won't loop or trip the 5-failure auto-pause.
set -euo pipefail

export PATH="$HOME/.toolbox/bin:/usr/local/bin:/usr/bin:/bin:$PATH"
MESHCLAW="$HOME/.toolbox/bin/meshclaw"
CRONS="$HOME/.meshclaw/crons.json"

[ -f "$CRONS" ] || exit 0
command -v aws >/dev/null 2>&1 || exit 0
[ -x "$MESHCLAW" ] || exit 0

# Only proceed once creds actually authenticate (same default chain meshclaw uses).
aws sts get-caller-identity >/dev/null 2>&1 || exit 0

# Enabled, non-user-paused jobs whose last run errored.
ids="$(python3 - "$CRONS" <<'PY'
import json, sys
for j in json.load(open(sys.argv[1])).get("jobs", []):
    if j.get("last_status") == "error" and j.get("enabled", True) and not j.get("user_paused"):
        print(j["id"])
PY
)"

[ -n "$ids" ] || exit 0
while read -r id; do
    [ -n "$id" ] || continue
    "$MESHCLAW" cron trigger "$id" || true
done <<< "$ids"
