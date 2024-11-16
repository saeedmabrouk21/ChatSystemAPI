class Application < ApplicationRecord
  self.locking_column = :lock_version

  has_many :chats, dependent: :destroy
  validates :token, presence: true, uniqueness: true
  validates :name, presence: true
end
