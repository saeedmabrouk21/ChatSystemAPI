config = YAML.load_file(Rails.root.join("config/elasticsearch.yml"))[Rails.env]
Elasticsearch::Model.client = Elasticsearch::Client.new(hosts: config["hosts"], log: true)
