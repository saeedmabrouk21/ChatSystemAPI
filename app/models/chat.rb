class Chat < ApplicationRecord
  belongs_to :application
  has_many :messages, dependent: :destroy

  validates :number, presence: true, uniqueness: { scope: :application_id }
  validates :messages_count, numericality: { greater_than_or_equal_to: 0 }

  before_create :initialize_message_max_number_in_redis

  def generate_message_number
    begin
      Redis.current.watch("chat:#{self.id}:messages_max_number") do
        current_count = Redis.current.get("chat:#{self.id}:messages_max_number").to_i
        new_count = current_count + 1

        # Use MULTI to start a transaction and execute the set atomically
        Redis.current.multi do
          Redis.current.set("chat:#{self.id}:messages_max_number", new_count)
        end

        return new_count # Return if the Redis operation succeeds
      end
    rescue Redis::WatchError
      retries += 1
      retry if retries < Rails.configuration.max_retries
    end

    # Fallback if Redis fails after retries
    self.messages.maximum(:number).to_i + 1
  end

  private

  def initialize_message_max_number_in_redis
    # Initialize the Redis counter for chats to 0 when the application is created
    Redis.current.set("chat:#{self.id}:messages_max_number", 0)
  end
end
