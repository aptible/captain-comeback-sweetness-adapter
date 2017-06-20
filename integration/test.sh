#!/bin/bash
set -o pipefail
set -o errexit
set -o nounset

REL_HERE=$(dirname "${BASH_SOURCE}")
HERE=$(cd "${REL_HERE}"; pwd)
cd "$HERE"

REDIS_TEST_PORT=8888

echo "=== Start Redis ==="
redis-server \
  --daemonize yes \
  --save "" \
  --appendonly no \
  --requirepass "FOO BAR" \
  --bind 127.0.0.1 \
  --port "$REDIS_TEST_PORT"

terminate_redis () {
  echo "=== Shutdown Redis ==="
  redis-cli -a "FOO BAR" -p "$REDIS_TEST_PORT" SHUTDOWN
}

trap terminate_redis EXIT

export REDIS_URL="redis://:FOO%20BAR@localhost:${REDIS_TEST_PORT}"
export SIDEKIQ_QUEUE="foo-queue"

redis-cli -a "FOO BAR" -p "$REDIS_TEST_PORT" FLUSHDB

echo "=== Check push ==="
python "${HERE}/push.py"

echo "=== Check task ==="
pushd app
bundle install
bundle exec sidekiq -q "$SIDEKIQ_QUEUE" -r ./app.rb
popd

echo "=== Check retry ==="
export REDIS_URL="redis://localhost:6380"
if [[ "$(python "${HERE}/push.py" 2>&1 | grep -ic "retry redis error")" != 1 ]]; then
  exit 1
fi
echo OK
