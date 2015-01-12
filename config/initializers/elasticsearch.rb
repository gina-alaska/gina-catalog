Searchkick.client = Elasticsearch::Client.new(hosts: ["192.168.222.225:9200"], retry_on_failure: true)
