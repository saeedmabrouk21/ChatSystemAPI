class Application < ApplicationRecord
  self.locking_column = :lock_version

  has_many :chats, dependent: :destroy
  validates :token, presence: true, uniqueness: true
  validates :name, presence: true

  before_create :initialize_chat_max_number_in_redis
  before_validation :assign_unique_token, on: :create

  def generate_chat_number
    NumberGeneratorService.new(self, nil).generate_chat_number
  end
  private

  def initialize_chat_max_number_in_redis
    # Initialize the Redis counter for chats to 0 when the application is created
    Redis.current.set("application:#{self.id}:chats_max_number", 0)
  end

  def assign_unique_token
    self.token = loop do
      token = SecureRandom.hex(10)
      break token unless Application.exists?(token: token)
    end
  end
end
