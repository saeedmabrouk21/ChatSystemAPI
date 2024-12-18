class Message < ApplicationRecord
  self.locking_column = :lock_version

  include Searchable

  mapping do
    indexes :body, type: "text", "analyzer": "ngram_analyzer"
    indexes :chat_id, type: "keyword"
  end

  belongs_to :chat

  validates :body, presence: true
  validates :number, presence: true, uniqueness: { scope: :chat_id }
end
