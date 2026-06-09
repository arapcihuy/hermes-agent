#!/bin/sh
# railway-entrypoint.sh — minimal entrypoint for Railway
# No s6-overlay, just run hermes gateway directly
set -e

export HOME=/opt/data
export PYTHONUNBUFFERED=1

# Ensure data directory exists
mkdir -p /opt/data/.hermes/logs
mkdir -p /opt/data/.hermes/skills

# Activate venv
. /opt/hermes/.venv/bin/activate

# Run hermes gateway (Telegram only for Railway)
exec hermes gateway start
