#!/usr/bin/env sh
# Generate unique secrets into n8n/.env (created from .env.example if missing).
# By default keeps N8N_ENCRYPTION_KEY so bundled demo credentials still decrypt.
# Usage:
#   ./scripts/gen-secrets.sh
#   ./scripts/gen-secrets.sh --rotate-encryption-key   # breaks demo creds until recreated
set -eu

ROOT="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
ENV_FILE="${ROOT}/n8n/.env"
EXAMPLE="${ROOT}/n8n/.env.example"
ROTATE_ENCRYPTION_KEY=0

for arg in "$@"; do
	case "$arg" in
	--rotate-encryption-key) ROTATE_ENCRYPTION_KEY=1 ;;
	-h | --help)
		sed -n '2,7p' "$0"
		exit 0
		;;
	*)
		printf 'Unknown option: %s\n' "$arg" >&2
		exit 1
		;;
	esac
done

if [ ! -f "$EXAMPLE" ]; then
	printf 'Missing %s\n' "$EXAMPLE" >&2
	exit 1
fi

if [ ! -f "$ENV_FILE" ]; then
	cp "$EXAMPLE" "$ENV_FILE"
	printf 'Created %s from .env.example\n' "$ENV_FILE"
fi

gen_secret() {
	# 32 bytes hex — works without Python; openssl is common on macOS/Linux.
	if command -v openssl >/dev/null 2>&1; then
		openssl rand -hex 32
	elif command -v head >/dev/null 2>&1 && [ -r /dev/urandom ]; then
		# Portable-ish fallback
		od -An -N32 -tx1 /dev/urandom | tr -d ' \n'
	else
		printf 'Need openssl or /dev/urandom to generate secrets\n' >&2
		exit 1
	fi
}

set_env() {
	key="$1"
	value="$2"
	if grep -q "^${key}=" "$ENV_FILE"; then
		# Avoid sed -i portability issues (BSD vs GNU).
		tmp="${ENV_FILE}.tmp"
		sed "s|^${key}=.*|${key}=${value}|" "$ENV_FILE" >"$tmp"
		mv "$tmp" "$ENV_FILE"
	else
		printf '%s=%s\n' "$key" "$value" >>"$ENV_FILE"
	fi
}

runners_token="$(gen_secret)"
searxng_secret="$(gen_secret)"
sandbox_api_key="$(gen_secret)"
registration_token="$(gen_secret)"
runner_key="$(gen_secret)"
postgres_user="n8n"
postgres_password="$(gen_secret)"
jwt_secret="$(gen_secret)"
qdrant_key="$(gen_secret)"

set_env N8N_RUNNERS_AUTH_TOKEN "$runners_token"
set_env SEARXNG_SECRET "$searxng_secret"
set_env SANDBOX_API_KEYS "$sandbox_api_key"
set_env N8N_SANDBOX_SERVICE_API_KEY "$sandbox_api_key"
set_env SANDBOX_API_RUNNER_REGISTRATION_TOKEN "$registration_token"
set_env SANDBOX_RUNNER_REGISTRATION_TOKEN "$registration_token"
set_env SANDBOX_API_RUNNER_API_KEY "$runner_key"
set_env SANDBOX_RUNNER_API_KEYS "$runner_key"
set_env POSTGRES_USER "$postgres_user"
set_env POSTGRES_PASSWORD "$postgres_password"
set_env N8N_USER_MANAGEMENT_JWT_SECRET "$jwt_secret"

# Demo Qdrant credential expects the default key unless you recreate it.
# Only rotate QDRANT_API_KEY when also rotating the encryption key (full reset).
if [ "$ROTATE_ENCRYPTION_KEY" -eq 1 ]; then
	encryption_key="$(gen_secret)"
	set_env N8N_ENCRYPTION_KEY "$encryption_key"
	set_env QDRANT_API_KEY "$qdrant_key"
	printf 'Rotated N8N_ENCRYPTION_KEY and QDRANT_API_KEY.\n'
	printf 'Bundled demo credentials will NOT decrypt — recreate Ollama/Qdrant credentials in the n8n UI.\n'
else
	set_env N8N_ENCRYPTION_KEY "super-secret-key"
	set_env QDRANT_API_KEY "qdrant"
	printf 'Kept N8N_ENCRYPTION_KEY=super-secret-key and QDRANT_API_KEY=qdrant for demo credentials.\n'
fi

chmod 600 "$ENV_FILE" 2>/dev/null || true
printf 'Updated secrets in %s\n' "$ENV_FILE"
