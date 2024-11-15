class Message < ApplicationRecord
  belongs_to :chat

  validates :body, presence: true
  validates :number, presence: true, uniqueness: { scope: :chat_id }

  # Callback to ensure message number is set correctly when creating a message
  before_create :set_number

  private

  def set_number
    # Automatically set the message number based on the messages_count of the chat
    self.number = chat.messages_count + 1
  end
end
