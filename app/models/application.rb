class Application < ApplicationRecord
  self.locking_column = :lock_version

  has_many :chats, dependent: :destroy
  validates :token, presence: true, uniqueness: true
  validates :name, presence: true

  before_create :initialize_chat_count_in_redis


  def generate_chat_number
    begin
      Redis.current.watch("application:#{self.token}:chats_max_number") do
        current_count = Redis.current.get("application:#{self.token}:chats_max_number").to_i
        new_count = current_count + 1

        # Use MULTI to start a transaction and execute the set atomically
        Redis.current.multi do
          Redis.current.set("application:#{self.token}:chats_max_number", new_count)
        end

        return new_count # Return if the Redis operation succeeds
      end
    rescue Redis::WatchError
      retries += 1
      retry if retries < Rails.configuration.max_retries
    end

    # Fallback if Redis fails after retries
    self.chats.maximum(:number).to_i + 1
  end

  private

  def initialize_chat_count_in_redis
    # Initialize the Redis counter for chats to 0 when the application is created
    Redis.current.set("application:#{self.token}:chats_max_number", 0)
  end
end
