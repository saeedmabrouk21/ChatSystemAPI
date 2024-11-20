# app/services/number_generator_service.rb
class NumberGeneratorService
  def initialize(application = nil, chat = nil)
    @application = application
    @chat = chat
  end

  def generate_chat_number
    return generate_number_for_chat(@application) if @application
    raise "Application is required for generating chat number."
  end

  def generate_message_number
    return generate_number_for_message(@chat) if @chat
    raise "Chat is required for generating message number."
  end


  private
  def generate_number_for_chat(application)
    begin
      Redis.current.watch("application:#{application.id}:chats_max_number") do
        current_count = Redis.current.get("application:#{application.id}:chats_max_number").to_i
        new_count = current_count + 1

        Redis.current.multi do
          Redis.current.set("application:#{application.id}:chats_max_number", new_count)
        end

        return new_count
      end
    rescue Redis::WatchError
      retry if retries < Rails.configuration.max_retries
    end

    # Fallback to finding the max chat number in the database
    application.chats.maximum(:number).to_i + 1
  end

  def generate_number_for_message(chat)
    begin
      Redis.current.watch("chat:#{chat.id}:messages_max_number") do
        current_count = Redis.current.get("chat:#{chat.id}:messages_max_number").to_i
        new_count = current_count + 1

        Redis.current.multi do
          Redis.current.set("chat:#{chat.id}:messages_max_number", new_count)
        end

        return new_count
      end
    rescue Redis::WatchError
      retry if retries < Rails.configuration.max_retries
    end

    # Fallback to finding the max message number in the database
    chat.messages.maximum(:number).to_i + 1
  end
end
