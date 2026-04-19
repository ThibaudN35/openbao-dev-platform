# openbao-dev-platform

Self-hosted OpenBao lab environment for local DevOps and security workflows.

This repository provides a minimal but structured OpenBao setup for local experimentation, reproducible lab usage, and portfolio documentation.

The project currently provides a simple, readable OpenBao setup based on Docker Compose:

- OpenBao `2.5`
- local file-based storage
- persistent data under `./volumes/openbao`
- local configuration in `./openbao/config.hcl`
- helper commands in `Makefile`

This repository is intentionally minimal at this stage. It is a local demo/lab environment, not a production-ready platform.

## Current structure

```text
.
├── docker-compose.yml
├── Makefile
├── openbao/
│   └── config.hcl
└── volumes/
    └── openbao/
```

## Requirements

- Docker
- Docker Compose
- `make`
- optionally the `bao` CLI on your machine if you want to interact with OpenBao outside the container

## OpenBao configuration

OpenBao runs with:

- port `8200` exposed on the host
- `IPC_LOCK` enabled
- `restart: unless-stopped`
- storage backend: local file storage
- UI enabled
- TLS disabled for local demo use

The server configuration lives in [`openbao/config.hcl`](./openbao/config.hcl).

## Quick start

Start the container:

```sh
make up
```

Check container status:

```sh
make ps
make logs
```

On first startup, initialize OpenBao manually:

```sh
make init
```

Then copy the generated root token and unseal keys into your local `.env` file and unseal the server:

```sh
make unseal
```

Check OpenBao status:

```sh
make status
```

Print the login command using the root token stored in `.env`:

```sh
make login
```

Stop the environment:

```sh
make down
```

## `.env` usage

The `Makefile` expects a local `.env` file for demo convenience. This file is ignored by Git.

Typical values expected by the current setup:

```dotenv
OPENBAO_CONTAINER_NAME=openbao
OPENBAO_ADDR=http://127.0.0.1:8200
OPENBAO_ROOT_TOKEN=replace-me
OPENBAO_UNSEAL_KEY_1=replace-me
OPENBAO_UNSEAL_KEY_2=replace-me
OPENBAO_UNSEAL_KEY_3=replace-me
```

## Available commands

```sh
make help
make up
make down
make restart
make logs
make ps
make status
make init
make unseal
make login
```

## Important note

This setup is for lab/demo use only.

- Unseal keys and the root token are handled through a local `.env` file for convenience.
- TLS is disabled.
- There is no auto-unseal, external storage backend, or production hardening.

For a real deployment, this would need a different security model, secure secret handling, and a production-grade OpenBao configuration.
