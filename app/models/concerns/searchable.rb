module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    settings index: {
      analysis: {
      analyzer: {
        ngram_analyzer: {
          tokenizer: "ngram_tokenizer"
        }
      },
      tokenizer: {
        ngram_tokenizer: {
          type: "ngram",
          min_gram: 2,
          max_gram: 3,
          token_chars: [
            "letter",
            "digit",
            "whitespace"
          ]
        }
      }
    }
    }
  end
end
