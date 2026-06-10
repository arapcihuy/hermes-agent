#!/bin/bash
set -ex

mkdir -p /opt/data/.hermes

cat > /opt/data/.hermes/config.yaml << EOF
telegram:
  bot_token: ${TELEGRAM_BOT_TOKEN}
  allowed_chats: ${TELEGRAM_ALLOWED_CHATS}
model:
  default: openrouter/owl-alpha
  provider: openrouter
providers:
  openrouter:
    base_url: https://openrouter.ai/api/v1
    api_key: ${OPENROUTER_API_KEY}
EOF

echo "=== Config ==="
cat /opt/data/.hermes/config.yaml

echo "=== Gateway run ==="
exec /opt/venv/bin/hermes gateway run
