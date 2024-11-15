module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    def self.search(query)
      params = {
        query: {
          multi_match: {
            query: query,
            fields: [ "body" ]
          }
        }
      }

      self.__elasticsearch__.search(params).records.to_a
    end
  end
end
