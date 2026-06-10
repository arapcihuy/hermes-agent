#!/bin/bash
set -e

echo "=== Hermes Railway Startup ==="

# Create .hermes directory
mkdir -p /opt/data/.hermes

# Generate config.yaml from Railway environment variables
cat > /opt/data/.hermes/config.yaml << EOF
telegram:
  bot_token: "${TELEGRAM_BOT_TOKEN}"
  allowed_chats: "${TELEGRAM_ALLOWED_CHATS}"
  streaming: true
model:
  default: "${HERMES_MODEL:-openrouter/owl-alpha}"
  provider: openrouter
providers:
  openrouter:
    base_url: https://openrouter.ai/api/v1
    api_key: "${OPENROUTER_API_KEY}"
EOF

echo "=== Config generated ==="
cat /opt/data/.hermes/config.yaml
echo "=== Checking hermes binary ==="
ls -la node_modules/hermes-agent/bin/ 2>/dev/null || echo "bin dir not found"
ls -la node_modules/.bin/hermes 2>/dev/null || echo "hermes bin not found"
echo "=== Starting hermes gateway ==="

# Start hermes gateway with debug
exec node node_modules/hermes-agent/bin/hermes.js gateway start 2>&1
