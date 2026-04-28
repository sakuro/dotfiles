---
name: start-hanami-dev-server
description: Start Hanami dev server (bin/dev) in background. Use proactively at the start of a Hanami development session, or whenever bin/dev is not running — e.g. when assets watch is needed for tests, when the web server must be up, or when the user asks to start the dev environment.
---

# Start Hanami Dev

Run `bin/dev` in the background using the Bash tool with `run_in_background: true`.

After launching, wait a few seconds, read the output file, and report the status of `[web]` and `[assets]` (always required). If other processes are present (e.g. `[islands]`), report their status as well.
