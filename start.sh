#!/bin/bash
set -ex

echo "=== Hermes Railway Startup ==="
mkdir -p /opt/data/.hermes

cat > /opt/data/.hermes/config.yaml << 'YAMLEOF'
telegram:
  bot_token: "TOKEN_PLACEHOLDER"
  allowed_chats: "CHATS_PLACEHOLDER"
  streaming: true
model:
  default: "openrouter/owl-alpha"
  provider: openrouter
providers:
  openrouter:
    base_url: https://openrouter.ai/api/v1
    api_key: "KEY_PLACEHOLDER"
YAMLEOF

# Replace placeholders with actual env vars
sed -i "s/TOKEN_PLACEHOLDER/${TELEGRAM_BOT_TOKEN}/g" /opt/data/.hermes/config.yaml
sed -i "s/CHATS_PLACEHOLDER/${TELEGRAM_ALLOWED_CHATS}/g" /opt/data/.hermes/config.yaml
sed -i "s/KEY_PLACEHOLDER/${OPENROUTER_API_KEY}/g" /opt/data/.hermes/config.yaml

echo "=== Config ==="
cat /opt/data/.hermes/config.yaml

echo "=== Python venv ==="
ls -la /opt/venv/bin/python* 2>/dev/null || echo "no python in venv"
/opt/venv/bin/python3 --version 2>/dev/null || echo "python not working"

echo "=== Starting gateway ==="
exec /opt/venv/bin/python3 -m hermes_agent gateway start 2>&1
