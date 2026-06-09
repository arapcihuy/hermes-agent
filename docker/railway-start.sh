#!/bin/sh
# Railway start script — bypass s6-overlay complexity, run gateway directly
set -e
export HOME=/opt/data
cd /opt/data
. /opt/hermes/.venv/bin/activate
exec s6-setuidgid hermes hermes gateway start
