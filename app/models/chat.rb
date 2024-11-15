class Chat < ApplicationRecord
  belongs_to :application

  validates :number, presence: true, uniqueness: { scope: :application_id }
  validates :messages_count, numericality: { greater_than_or_equal_to: 0 }

  # Callback to ensure the number is set correctly when creating a chat
  before_create :set_number

  private

  def set_number
    # Automatically set the chat number based on the chats_count of the application
    self.number = application.chats_count + 1
  end
end
