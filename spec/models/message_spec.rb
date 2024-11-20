require 'rails_helper'

RSpec.describe Message, type: :model do
  # Clean up Redis before each test to avoid any interference with Elasticsearch
  before(:each) do
    # Clean Redis and Elasticsearch (optional)
    Redis.current.flushdb
    # Clear Elasticsearch index before each test (optional)
    Elasticsearch::Model.client.indices.delete(index: 'messages') rescue nil
    Elasticsearch::Model.client.indices.create(index: 'messages', body: { mappings: Message.mappings.to_hash }) rescue nil
  end

  # Test associations
  it { should belong_to(:chat) }

  # Test validations
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:number) }
  it { should validate_uniqueness_of(:number).scoped_to(:chat_id) }


  # Test creating a message
  describe 'creating a message' do
    let(:chat) { create(:chat) }

    it 'creates a valid message' do
      message = build(:message, chat: chat)
      expect(message).to be_valid
    end

    it 'does not allow duplicate number within the same chat' do
      create(:message, chat: chat, number: 1)
      message = build(:message, chat: chat, number: 1)
      expect(message).not_to be_valid
      expect(message.errors[:number]).to include('has already been taken')
    end

    it 'requires a body' do
      message = build(:message, chat: chat, body: nil)
      expect(message).not_to be_valid
      expect(message.errors[:body]).to include("can't be blank")
    end
  end
end
