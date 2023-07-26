#!/bin/bash
set -o pipefail
set -o errexit
set -o nounset

REL_HERE=$(dirname "${BASH_SOURCE}")
HERE=$(cd "${REL_HERE}"; pwd)
cd "$HERE"

sleep 5 # Give redis and influx a moment to start

redis-cli -h redis FLUSHDB
python "${HERE}/influx.py" "clear"

echo "=== Check push ==="
python "${HERE}/push.py"
python "${HERE}/push.py"

echo "=== Check task ==="
pushd app
bundle install
bundle exec sidekiq -q "$SIDEKIQ_QUEUE" -r ./app.rb
popd

echo "=== Check metrics ==="
python "${HERE}/influx.py" "check" "foo-container" 2

echo "=== Check metrics don't block ==="
export INFLUXDB_HOST=fake
pushd app
if [[ "$(python "${HERE}/push.py" -r ./app.rb 2>&1 | grep -ic "enqueued restart")" != 1 ]]; then
  exit 1
fi
popd

echo "=== Check retry ==="
export REDIS_URL="redis://fake:6380"
if [[ "$(python "${HERE}/push.py" 2>&1 | grep -ic "retry redis error")" != 1 ]]; then
  exit 1
fi
echo OK
