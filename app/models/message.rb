class Message < ApplicationRecord
  self.locking_column = :lock_version

  include Searchable

  mapping do
    indexes :body, type: "text"
  end

  belongs_to :chat

  validates :body, presence: true
  validates :number, presence: true, uniqueness: { scope: :chat_id }

  def self.search_in_chat(search_term, chat_id)
    params = {
        "query": {
          "bool": {
            "must": [
              { "match": { "body": search_term } }
            ],
            "filter": [
              { "term":  { "chat_id": chat_id } }
            ]
          }
        }
      }
    self.__elasticsearch__.search(params).records.to_a
  end
end
