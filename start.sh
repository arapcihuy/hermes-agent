#!/bin/bash
set -ex

echo "=== Hermes Railway Startup ===" | tee /opt/data/.hermes/startup.log
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

sed -i "s/TOKEN_PLACEHOLDER/${TELEGRAM_BOT_TOKEN}/g" /opt/data/.hermes/config.yaml
sed -i "s/CHATS_PLACEHOLDER/${TELEGRAM_ALLOWED_CHATS}/g" /opt/data/.hermes/config.yaml
sed -i "s/KEY_PLACEHOLDER/${OPENROUTER_API_KEY}/g" /opt/data/.hermes/config.yaml

echo "=== Config ===" | tee -a /opt/data/.hermes/startup.log
cat /opt/data/.hermes/config.yaml | tee -a /opt/data/.hermes/startup.log

echo "=== Hermes version ===" | tee -a /opt/data/.hermes/startup.log
/opt/venv/bin/hermes --version 2>&1 | tee -a /opt/data/.hermes/startup.log

echo "=== Starting gateway ===" | tee -a /opt/data/.hermes/startup.log
exec /opt/venv/bin/hermes gateway start 2>&1 | tee -a /opt/data/.hermes/startup.log
