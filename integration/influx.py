import os
import sys
import influxdb


CLIENT = influxdb.InfluxDBClient(
        host=os.environ['INFLUXDB_HOST'],
        port=os.environ['INFLUXDB_PORT'],
        database=os.environ['INFLUXDB_DATABASE'],
        username=os.environ['INFLUXDB_USER'],
        password=os.environ['INFLUXDB_PASSWORD'],
        ssl=os.environ['INFLUXDB_SSL'],
        verify_ssl=os.environ['INFLUXDB_SSL'],
        timeout=30
)

if sys.argv[1] == 'check':
        result_raw = CLIENT.query(
                        'select * from captain_comeback_restarts where container_id=$c;',
                        bind_params={'c': sys.argv[2]}
                )
        result = list(result_raw.get_points())
        if len(result) != int(sys.argv[3]):
                print("Influx Result: {0}".format(result))
                raise Exception('Unexpected number of results')
elif sys.argv[1] == 'clear':
        CLIENT.drop_measurement('captain_comeback_restarts')