require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe RecalculateCountsJob, type: :job do
  # Enable testing for Sidekiq jobs
  Sidekiq::Testing.fake!

  let!(:application1) { create(:application) }
  let!(:application2) { create(:application) }
  let!(:chat1) { create(:chat, application: application1) }
  let!(:chat2) { create(:chat, application: application1) }
  let!(:chat3) { create(:chat, application: application2) }
  let!(:message1) { create(:message, chat: chat1) }
  let!(:message2) { create(:message, chat: chat1) }
  let!(:message3) { create(:message, chat: chat2) }
  let!(:message4) { create(:message, chat: chat3) }

  # Test that the job correctly updates chats_count in applications
  describe '#perform' do
    it 'recalculates and updates chats_count for each application' do
      RecalculateCountsJob.new.perform

      application1.reload
      application2.reload

      expect(application1.chats_count).to eq(2)
      expect(application2.chats_count).to eq(1)
    end

    it 'recalculates and updates messages_count for each chat' do
      RecalculateCountsJob.new.perform

      chat1.reload
      chat2.reload
      chat3.reload

      expect(chat1.messages_count).to eq(2)
      expect(chat2.messages_count).to eq(1)
      expect(chat3.messages_count).to eq(1)
    end
  end

  describe 'Job enqueuing' do
    it 'enqueues the RecalculateCountsJob' do
      expect {
        RecalculateCountsJob.perform_async
      }.to change(Sidekiq::Queues['default'], :size).by(1)
    end
  end
end
