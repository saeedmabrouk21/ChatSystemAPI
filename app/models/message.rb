class Message < ApplicationRecord
  include Searchable

  mapping do
    indexes :body, type: "text"
  end

  belongs_to :chat

  validates :body, presence: true
  validates :number, presence: true, uniqueness: { scope: :chat_id }
end
