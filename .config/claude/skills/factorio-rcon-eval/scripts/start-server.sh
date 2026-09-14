#!/usr/bin/env bash
# Create a throwaway save and start a headless, RCON-enabled Factorio server
# for it via factorix. Prints the state directory to stdout on success;
# everything else goes to stderr. The caller must pass the state directory
# to eval.sh and stop-server.sh.
#
# Usage: start-server.sh [port] [password]
set -euo pipefail

PORT="${1:-$(( (RANDOM % 20000) + 30000 ))}"
PASSWORD="${2:-$(printf '%04x%04x' "$RANDOM" "$RANDOM")}"
STATE_DIR="$(mktemp -d "${TMPDIR:-/tmp}/factorio-rcon-eval.XXXXXX")"
SAVE="$STATE_DIR/eval.zip"

echo "Creating temporary save: $SAVE" >&2
# The path passed to --create MUST be absolute. A relative path fails to
# resolve inside the Factorio process; instead of creating the save and
# exiting, it silently falls back to launching the normal interactive
# desktop game, popping a GUI window on the user's screen.
factorix launch --wait -- --create "$SAVE" >"$STATE_DIR/create.log" 2>&1

if [ ! -f "$SAVE" ]; then
  echo "Failed to create save file; see $STATE_DIR/create.log" >&2
  exit 1
fi

echo "Starting RCON server on port $PORT" >&2
# `factorix launch` returns as soon as it has spawned the factorio process --
# it does not wait for the server to become ready. Factorio then daemonizes
# (it closes stdin/stdout, logged as "Got EOF on stdin; closing") and keeps
# running detached from this command. Because of this, anything that judges
# liveness by watching this command's own stdio (e.g. a background-task
# runner reporting "completed") can be wrong: that only means the launcher
# step finished, not that the server exited. Liveness must be checked by
# looking for the process itself, which is what the polling loops below do.
factorix launch -- --start-server "$SAVE" --rcon-port "$PORT" --rcon-password "$PASSWORD" \
  >"$STATE_DIR/server.log" 2>&1

for _ in $(seq 1 30); do
  pgrep -f -- "factorio --start-server $SAVE" >/dev/null && break
  sleep 1
done

if ! pgrep -f -- "factorio --start-server $SAVE" >/dev/null; then
  echo "Server process never appeared; see $STATE_DIR/server.log" >&2
  exit 1
fi

for _ in $(seq 1 30); do
  factorix rcon eval "rcon.print(1)" --port "$PORT" --password "$PASSWORD" >/dev/null 2>&1 && break
  sleep 1
done

if ! factorix rcon eval "rcon.print(1)" --port "$PORT" --password "$PASSWORD" >/dev/null 2>&1; then
  echo "RCON never became ready; see $STATE_DIR/server.log" >&2
  exit 1
fi

cat > "$STATE_DIR/info.env" <<EOF
PORT=$PORT
PASSWORD=$PASSWORD
SAVE=$SAVE
EOF

echo "$STATE_DIR"
