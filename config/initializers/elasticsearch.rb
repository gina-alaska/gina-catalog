Searchkick.client = Elasticsearch::Client.new(hosts: ["#{Rails.application.secrets.elasticsearch_host}:9200"], retry_on_failure: true)
