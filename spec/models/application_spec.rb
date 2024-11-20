require 'rails_helper'

RSpec.describe Application, type: :model do
  # Test validations
  it { should validate_presence_of(:name) }

  # Test associations
  it { should have_many(:chats).dependent(:destroy) }

  # Test callbacks
  describe 'callbacks' do
    context 'before create' do
      it 'initializes chat max number in redis' do
        application = create(:application)
        expect(Redis.current.get("application:#{application.id}:chats_max_number")).to eq('0')
      end

      it 'assigns a unique token' do
        application = create(:application)
        expect(application.token).not_to be_nil
        expect(application.token.length).to eq(20)
      end
    end
  end

  # Test methods
  describe '#generate_chat_number' do
    let(:application) { create(:application) }

    it 'returns a new chat number' do
      chat_number = application.generate_chat_number
      expect(chat_number).to be_a(Integer)
      expect(chat_number).to be > 0  
    end
  end

  # Test edge cases for the unique token generation
  describe 'assign_unique_token' do
    it 'ensures token is unique' do
      existing_application = create(:application)
      new_application = build(:application)
      # Ensure a new token is generated, even if one exists
      expect(new_application.token).not_to eq(existing_application.token)
    end
  end
end
