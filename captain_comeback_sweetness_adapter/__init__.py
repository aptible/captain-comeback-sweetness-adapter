# coding:utf-8
import os
import time
import json
import binascii
import logging

import redis


logger = logging.getLogger('captain_comeback_sweetness_adapter')

REDIS_URL = os.environ["REDIS_URL"]
SIDEKIQ_QUEUE = os.environ["SIDEKIQ_QUEUE"]

POOL = redis.BlockingConnectionPool.from_url(
    REDIS_URL, decode_components=True, max_connections=1,
)


def restart(cg, retried=False):
    jid = binascii.hexlify(os.urandom(12)).decode('utf-8')

    payload = {
        "jid": jid,
        "enqueued_at": time.time(),
        "class": "Sweetness::Tasks::RecoverContainer",
        "args": [0, cg.name()]
    }

    try:
        r = redis.StrictRedis(connection_pool=POOL)
        r.sadd("queues", SIDEKIQ_QUEUE)
        r.lpush("queue:{0}".format(SIDEKIQ_QUEUE), json.dumps(payload))
    except redis.RedisError as e:
        if retried:
            raise
        logger.warning("%s: retry Redis error: %s", cg.name(), e)
        restart(cg, True)
    else:
        logger.info("%s: enqueued restart: %s", cg.name(), jid)


__author__ = "Thomas Orozco"
__email__ = "thomas@aptible.com"
__version__ = "0.1.0"
__all__ = ['restart']
