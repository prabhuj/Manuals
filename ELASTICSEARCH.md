# ELASTICSEARCH Installation

mkdir /app

chmod -R 777 /app

sudo wget --no-check-certificate https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/2.1.1/elasticsearch-2.1.1.tar.gz -P /app/

sudo tar -zvxf /app/elasticsearch-2.1.1.tar.gz --directory /app/

sudo vim /app/elasticsearch-2.1.1/config/elasticsearch.yml

```
You will want to restrict outside access to your Elasticsearch instance (port 9200), so outsiders cant read your data or shutdown your Elasticsearch cluster through the HTTP API. Find the line that specifies network.host, uncomment it, and replace its value with "localhost" so it looks like this:
network.host: localhost

To make it accessible to others
network.host: 0.0.0.0
```

/app/elasticsearch-2.1.1/bin/elasticsearch -d

ps -ef | grep elasticsearch

curl http://localhost:9200/?pretty

```
{
  "name" : "Postman",
  "cluster_name" : "elasticsearch",
  "version" : {
    "number" : "2.1.1",
    "build_hash" : "40e2c53a6b6c2972b3d13846e450e66f4375bd71",
    "build_timestamp" : "2015-12-15T13:05:55Z",
    "build_snapshot" : false,
    "lucene_version" : "5.3.1"
  },
  "tagline" : "You Know, for Search"
}
```

curl 'localhost:9200/_cat/health?v'

```
epoch      timestamp cluster       status node.total node.data shards pri relo init unassign pending_tasks max_task_wait_time active_shards_percent
1453766776 16:06:16  elasticsearch green           1         1      0   0    0    0        0             0                  -                100.0%
```

curl -XPOST 'http://localhost:9200/_shutdown'

To restart elasticsearch automatically when the server is rebooted,

sudo update-rc.d elasticsearch defaults 95 10

