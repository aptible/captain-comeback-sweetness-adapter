# coding:utf-8
import os
import time
import json
import binascii
import logging

import redis
import influxdb


logger = logging.getLogger('captain_comeback_sweetness_adapter')

REDIS_URL = os.environ["REDIS_URL"]
SIDEKIQ_QUEUE = os.environ["SIDEKIQ_QUEUE"]

POOL = redis.BlockingConnectionPool.from_url(
    REDIS_URL, decode_components=True, max_connections=1,
)
INFLUX_CLIENT = influxdb.InfluxDBClient(
    host=os.getenv('INFLUXDB_HOST'),
    port=os.getenv('INFLUXDB_PORT'),
    database=os.getenv('INFLUXDB_DATABASE'),
    username=os.getenv('INFLUXDB_USER'),
    password=os.getenv('INFLUXDB_PASSWORD'),
    ssl=os.getenv("INFLUXDB_SSL", 'False').lower() in ('true', '1', 't'),
    verify_ssl=os.getenv("INFLUXDB_SSL", 'False').lower() in ('true', '1', 't'),
    timeout=30
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
        
    try:
        host = os.environ['INFLUXDB_HOST']
        port = os.environ['INFLUXDB_PORT']
        db = os.environ['INFLUXDB_DATABASE']
        logger.info("Writing metrics to %s:%s/%s", host, port, db)

        INFLUX_CLIENT.write_points([
            {
                'measurement': 'captain_comeback_restarts',
                'tags': {
                    'container_id': cg.name(),
                    'queue': SIDEKIQ_QUEUE,
                },
                'fields': {
                    'retried': 1,
                    'job_id': jid
                }
            }
        ])
    except (influxdb.exceptions.InfluxDBClientError, influxdb.exceptions.InfluxDBServerError) as e:
        logger.warning(e)
        logger.warning("Error writing to captain comeback restart metrics: JID %s; CID %s", jid, cg.name())
        


__author__ = "Thomas Orozco"
__email__ = "thomas@aptible.com"
__version__ = "0.1.0"
__all__ = ['restart']
