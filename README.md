Dotfiles for Ubuntu and macOS.

```
curl -fsSL https://dot.2238.club | bash
```

## Requirements

macOS needs Apple Silicon. Homebrew itself is not required.

Usually preinstalled:

- bash, tar, and shasum (macOS) or sha256sum (Ubuntu)
- curl on macOS

On Ubuntu, minimal installs such as container images may lack these:

- curl
- sudo, which the pre-packages hook calls before any package is installed
