#!/bin/bash
set -ex

echo "=== Hermes Railway Startup ==="
mkdir -p /opt/data/.hermes

# Generate config
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

sed -i "s/TOKEN_PLACEHOLDER/${TELEGRAM_BOT_TOKEN}/g" /opt/data/.hermes/config.yaml
sed -i "s/CHATS_PLACEHOLDER/${TELEGRAM_ALLOWED_CHATS}/g" /opt/data/.hermes/config.yaml
sed -i "s/KEY_PLACEHOLDER/${OPENROUTER_API_KEY}/g" /opt/data/.hermes/config.yaml

echo "=== Config ==="
cat /opt/data/.hermes/config.yaml

echo "=== Checking hermes package ==="
pip show hermes-agent 2>&1 | head -5
echo "---"
python3 -c "from hermes_cli.main import main; print('hermes_cli OK')" 2>&1 || echo "import failed"

echo "=== Starting gateway ==="
# Use the hermes CLI entry point
exec python3 -m hermes_cli gateway start 2>&1
