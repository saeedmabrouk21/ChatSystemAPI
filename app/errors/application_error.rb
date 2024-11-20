# app/errors/application_error.rb
class ApplicationError < StandardError
  def initialize(message = "An error occurred")
    super(message)
  end
end

class ApplicationNotFoundError < ApplicationError
  def initialize(message = "Application not found.")
    super(message)
  end
end

class ChatNotFoundError < ApplicationError
  def initialize(message = "Chat not found.")
    super(message)
  end
end

class MessageNotFoundError < ApplicationError
  def initialize(message = "Message not found.")
    super(message)
  end
end
