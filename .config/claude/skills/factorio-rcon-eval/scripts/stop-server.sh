#!/usr/bin/env bash
# Stop the server started by start-server.sh and remove its temporary save
# and state directory. Always call this when done, including on error paths
# -- an orphaned server keeps holding its RCON port and a running-but-hidden
# process on the user's machine.
#
# Usage: stop-server.sh <state-dir>
set -euo pipefail

STATE_DIR="$1"

# shellcheck disable=SC1091
source "$STATE_DIR/info.env"

factorix rcon exec "/quit" --port "$PORT" --password "$PASSWORD" >/dev/null 2>&1 || true

for _ in $(seq 1 10); do
  pgrep -f -- "factorio --start-server $SAVE" >/dev/null || break
  sleep 1
done

# /quit should be enough, but don't leave an orphaned Factorio process
# behind if it didn't take effect.
if pgrep -f -- "factorio --start-server $SAVE" >/dev/null; then
  pkill -f -- "factorio --start-server $SAVE" || true
fi

rm -rf "$STATE_DIR"
