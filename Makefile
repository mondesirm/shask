# Convenience targets — run from the repo root.
COMPOSE := docker compose --project-directory n8n -f n8n/compose.yml
PROFILE ?= cpu

.PHONY: env secrets up up-cpu up-gpu up-amd up-mac down pull logs ps config bump

env:
	@test -f n8n/.env || cp n8n/.env.example n8n/.env
	@echo "n8n/.env ready (edit secrets or run: make secrets)"

secrets: env
	./scripts/gen-secrets.sh

up: up-$(PROFILE)

up-cpu: env
	$(COMPOSE) --profile cpu up

up-gpu: env
	$(COMPOSE) --profile gpu-nvidia up

up-amd: env
	$(COMPOSE) --profile gpu-amd up

# Mac / Apple Silicon with Ollama on the host (no Docker Ollama profile).
up-mac: env
	$(COMPOSE) up

down:
	$(COMPOSE) --profile cpu --profile gpu-nvidia --profile gpu-amd down

pull:
	$(COMPOSE) --profile $(PROFILE) pull

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

config:
	$(COMPOSE) --profile cpu config >/dev/null
	@echo "compose config OK"

bump:
	curl -fsSL https://get.n8n.io | sh -s -- --upgrade
