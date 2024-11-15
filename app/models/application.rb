class Application < ApplicationRecord
  has_many :chats
  validates :token, presence: true, uniqueness: true
  validates :name, presence: true
end
