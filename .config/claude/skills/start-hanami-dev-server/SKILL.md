---
name: start-hanami-dev-server
description: Start the Hanami dev services (pitchfork daemons, or bin/dev in background). Use proactively at the start of a Hanami development session, or whenever the dev services are not running — e.g. when assets watch is needed for tests, when the web server must be up, or when the user asks to start the dev environment.
---

# Start Hanami Dev

## Projects with `pitchfork.toml`

The pitchfork supervisor keeps the daemons running, so start them with pitchfork instead of running `bin/dev` in the background.

1. Run `pitchfork start --local -q` in the foreground (`-q` suppresses the startup logs, which can be hundreds of KB). It returns once every daemon is ready and fails if one of them does not become ready; daemons already running are left as they are.
2. Run `pitchfork list --project` and report the state of each daemon (without `--project` it lists the daemons of every project).
3. For a daemon that failed, read its log with `pitchfork logs <daemon> -n 100 --no-pager` and report the cause.

Stop the daemons with `pitchfork stop --local` only when the user asks.

## Other projects

Run `bin/dev` in the background using the Bash tool with `run_in_background: true`.

After launching, wait a few seconds, read the output file, and report the status of `[web]` and `[assets]` (always required). If other processes are present (e.g. `[islands]`), report their status as well.
