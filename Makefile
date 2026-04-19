# WARNING:
# This Makefile is intended for LAB / DEMO use only.
# It relies on highly sensitive secrets stored in a local .env file
# (root token and unseal keys), which is NOT an acceptable practice in production.
# In production, unseal automation should rely on dedicated mechanisms
# such as KMS/HSM/auto-unseal, and critical secrets must be handled securely.

include .env
export

COMPOSE ?= docker compose
CONTAINER ?= $(OPENBAO_CONTAINER_NAME)

.PHONY: help up down restart logs ps status init unseal login

help:
	@echo "Available targets:"
	@echo "  make up       - Start OpenBao container"
	@echo "  make down     - Stop and remove container"
	@echo "  make restart  - Restart container"
	@echo "  make logs     - Follow container logs"
	@echo "  make ps       - Show compose status"
	@echo "  make status   - Show OpenBao status"
	@echo "  make init     - Initialize OpenBao manually"
	@echo "  make unseal   - Unseal OpenBao using keys from .env"
	@echo "  make login    - Export root token usage hint"

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

restart:
	$(COMPOSE) restart

logs:
	$(COMPOSE) logs -f $(CONTAINER)

ps:
	$(COMPOSE) ps

status:
	docker exec -it $(CONTAINER) bao status

init:
	@echo "Initialize OpenBao manually and copy the generated root token / unseal keys into .env"
	docker exec -it $(CONTAINER) bao operator init

unseal:
	docker exec -it $(CONTAINER) bao operator unseal $(OPENBAO_UNSEAL_KEY_1)
	docker exec -it $(CONTAINER) bao operator unseal $(OPENBAO_UNSEAL_KEY_2)
	docker exec -it $(CONTAINER) bao operator unseal $(OPENBAO_UNSEAL_KEY_3)

login:
	@echo "Use this command to authenticate with the root token:"
	@echo "export BAO_ADDR=$(OPENBAO_ADDR) && bao login $(OPENBAO_ROOT_TOKEN)"

debug-env:
	@echo "OPENBAO_ADDR=$(OPENBAO_ADDR)"
	@echo "OPENBAO_CONTAINER_NAME=$(OPENBAO_CONTAINER_NAME)"
	@echo "OPENBAO_ROOT_TOKEN=$(OPENBAO_ROOT_TOKEN)"
	@echo "OPENBAO_UNSEAL_KEY_1=$(OPENBAO_UNSEAL_KEY_1)"