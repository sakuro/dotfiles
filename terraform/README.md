# terraform

Infrastructure for `dot.2238.club`, which serves `bootstrap.sh` for the one-liner in the top-level README.

## Architecture

- CloudFront distribution in front of `raw.githubusercontent.com`, with caching disabled
- CloudFront Function that rewrites requests:
  - `/` → `bootstrap.sh`
  - allowlisted mise config files → the same path in the repository
  - anything else → 404
- ACM certificate (us-east-1)
- Gandi LiveDNS records for the CNAME and certificate validation

When `bootstrap.sh` starts fetching another file through this site, add its path to `allowed` in the CloudFront Function in `main.tf`.

## Prerequisites

- Run `mise install` in this directory to install the tools.
- The `init`, `plan` and `apply` mise tasks run terraform through `fnox exec`, which exports the following secrets defined in `fnox.toml`. 1Password must be signed in when they run.
  - `GANDI_PERSONAL_ACCESS_TOKEN`
  - `TF_TOKEN_app_terraform_io` (HCP Terraform, where the state is stored)
- mise sets `AWS_PROFILE=terraform`. Define the profile in `~/.aws/config`:

  ```ini
  [profile terraform]
  credential_process = aws-terraform-credential-process
  ```

  `bin/aws-terraform-credential-process` assumes `TerraformExecutionRole` with MFA.

## Usage

```sh
mise run init
mise run plan
mise run apply
tflint
```

## CI

CI runs `terraform fmt -check`, `terraform validate` and `tflint` only. It has no cloud credentials because the Gandi token cannot be scoped to read-only, so `plan` and `apply` are run locally.
