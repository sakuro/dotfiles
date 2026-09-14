#!/usr/bin/env bash
# Send one Lua snippet to the server started by start-server.sh via RCON.
# `factorix rcon eval` wraps the snippet in /c before sending it, so use
# rcon.print(...) to get a value back on stdout.
#
# Usage: eval.sh <state-dir> <lua-code>
set -euo pipefail

STATE_DIR="$1"
LUA_CODE="$2"

# shellcheck disable=SC1091
source "$STATE_DIR/info.env"

factorix rcon eval "$LUA_CODE" --port "$PORT" --password "$PASSWORD"
