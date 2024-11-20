require "sidekiq-scheduler"

class RecalculateCountsJob
  include Sidekiq::Job

  def perform(*args)
    # Recalculate chats_count for each application
    Application.find_each do |application|
      new_chats_count = application.chats.count
      application.update(chats_count: new_chats_count)
      Rails.logger.info "Updated chats_count for Application ##{application.id}: #{new_chats_count}"
    end

    # Recalculate messages_count for each chat
    Chat.find_each do |chat|
      new_messages_count = chat.messages.count
      chat.update(messages_count: new_messages_count)
      Rails.logger.info "Updated messages_count for Chat ##{chat.id}: #{new_messages_count}"
    end
  end
end
