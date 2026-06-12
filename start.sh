#!/bin/bash
set -ex

mkdir -p /opt/data/.hermes

# Generate .env file with API keys
cat > /opt/data/.hermes/.env << EOF
OPENROUTER_API_KEY=${OPEN...n
# Generate config.yaml — read model from HERMES_MODEL env var, fallback to openrouter/owl-alpha
HERMES_MODEL="${HERMES_MODEL:-openrouter/owl-alpha}"

cat > /opt/data/.hermes/config.yaml << EOF
telegram:
  bot_token: ${TELEGRAM_BOT_TOKEN}
  allowed_chats: ${TELEGRAM_ALLOWED_CHATS}
model:
  default: ${HERMES_MODEL}
  provider: openrouter
providers:
  openrouter:
    base_url: https://openrouter.ai/api/v1
EOF

echo "=== .env ==="
cat /opt/data/.hermes/.env

echo "=== Config ==="
cat /opt/data/.hermes/config.yaml

echo "=== Gateway run ==="
exec /opt/venv/bin/hermes gateway run
