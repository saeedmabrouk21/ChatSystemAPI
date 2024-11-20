require 'rails_helper'

RSpec.describe Chat, type: :model do
  # Test associations
  it { should belong_to(:application) }
  it { should have_many(:messages).dependent(:destroy) }

  # Test validations
  it { should validate_presence_of(:number) }
  it { should validate_uniqueness_of(:number).scoped_to(:application_id) }
  it { should validate_numericality_of(:messages_count).is_greater_than_or_equal_to(0) }

  # Test methods
  describe '#generate_message_number' do
    let(:chat) { create(:chat) }

    it 'returns a new message number' do
      message_number = chat.generate_message_number
      expect(message_number).to be_a(Integer)
      expect(message_number).to be > 0
    end
  end
end
