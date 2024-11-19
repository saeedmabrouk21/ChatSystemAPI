# lib/tasks/elasticsearch.rake
namespace :elasticsearch do
  desc "Create Elasticsearch index for messages"
  task create_message_index: :environment do
    Message.__elasticsearch__.create_index! force: true
  end
end
