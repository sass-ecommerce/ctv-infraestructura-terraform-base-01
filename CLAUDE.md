# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

This repository provisions the **Terraform remote state backend** for the `chapa-tu-venta` project. It is a one-time bootstrap step that must be applied before any other environment-specific Terraform repositories can be used.

It creates:
- An S3 bucket (`ctv-terraform-state-<account-id>`) for storing Terraform state
- Versioning, AES256 server-side encryption, and full public access blocking on that bucket

## Commands

All commands run from the `bootstrap/` directory.

```bash
# Initialize (no remote backend — state is stored locally for this bootstrap)
terraform init

# Preview changes
terraform plan

# Apply
terraform apply

# Destroy (only if tearing down the backend entirely)
terraform destroy
```

Outputs after apply:
- `state_bucket_name` — the S3 bucket name to reference in `backend.tf` of environment repos
- `state_lock_table_name` — the DynamoDB table name for state locking
- `account_id` — the AWS account ID

## Architecture

```
bootstrap/
  versions.tf   — terraform{} block with required_version and required_providers
  variables.tf  — aws_region (default: us-east-1)
  main.tf       — S3 bucket (versioning + encryption + public-access-block) + DynamoDB lock table
  outputs.tf    — state_bucket_name, state_lock_table_name, account_id
```

The bootstrap module has **no remote backend** — its own state is local. This is intentional: it must run before the remote backend exists.

## Constraints

- Requires Terraform `>= 1.10.0` and AWS provider `~> 6.0`.
- AWS credentials must be configured in the environment (`AWS_PROFILE`, `AWS_ACCESS_KEY_ID`/`AWS_SECRET_ACCESS_KEY`, or an IAM role) before running any command.
- `.tfvars` files are gitignored and should never be committed.
- The bucket name is derived from the AWS account ID — it is not configurable.
