# app/services/search_service.rb
class SearchService
  def initialize(model)
    @model = model
  end

  # Perform search in a specific chat's messages with a custom analyzer
  def search_in_chat(search_term, chat_id)
    params = {
      query: {
        bool: {
          must: [
            { match: { body: { query: search_term, analyzer: "ngram_analyzer" } } }
          ],
          filter: [
            { term: { chat_id: chat_id } }
          ]
        }
      }
    }
    @model.__elasticsearch__.search(params).records.to_a
  end
end
