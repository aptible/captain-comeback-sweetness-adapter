#!/bin/bash
set -o pipefail
set -o errexit
set -o nounset

REL_HERE=$(dirname "${BASH_SOURCE}")
HERE=$(cd "${REL_HERE}"; pwd)
cd "$HERE"

export REDIS_URL="redis://localhost:6379"
export SIDEKIQ_QUEUE="foo-queue"

redis-cli flushdb

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
