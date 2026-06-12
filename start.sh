#!/bin/bash
set -ex

mkdir -p /opt/data/.hermes

# Generate .env — use printf to avoid heredoc expansion issues with special chars
printf 'OPENROUTER_API_KEY=%s\n' "$OPENROUTER_API_KEY" > /opt/data/.hermes/.env

# Set model from env var with fallback
HERMES_MODEL="${HERMES_MODEL:-openrouter/owl-alpha}"

# Generate config.yaml
cat > /opt/data/.hermes/config.yaml << CFGEOF
telegram:
  bot_token: ${TELEGRAM_BOT_TOKEN}
  allowed_chats: ${TELEGRAM_ALLOWED_CHATS}
model:
  default: ${HERMES_MODEL}
  provider: openrouter
providers:
  openrouter:
    base_url: https://openrouter.ai/api/v1
CFGEOF

echo "=== .env ==="
cat /opt/data/.hermes/.env

echo "=== Config ==="
cat /opt/data/.hermes/config.yaml

echo "=== Gateway run ==="
exec /opt/venv/bin/hermes gateway run
