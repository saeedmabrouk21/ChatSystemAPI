class Chat < ApplicationRecord
  belongs_to :application
  has_many :messages, dependent: :destroy

  validates :number, presence: true, uniqueness: { scope: :application_id }
  validates :messages_count, numericality: { greater_than_or_equal_to: 0 }

  before_create :initialize_message_max_number_in_redis

  def generate_message_number
    NumberGeneratorService.new(nil, self).generate_message_number
  end

  private

  def initialize_message_max_number_in_redis
    # Initialize the Redis counter for chats to 0 when the application is created
    Redis.current.set("chat:#{self.id}:messages_max_number", 0)
  end
end
