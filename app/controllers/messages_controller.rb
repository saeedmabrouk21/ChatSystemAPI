class MessagesController < ApplicationController
  before_action :set_application
  before_action :set_chat
  before_action :set_message, only: [ :show, :update ]

  # GET /applications/:application_token/chats/:chat_number/messages
  def index
    @messages = @chat.messages.order(:number)
    render json: MessageSerializer.new(@messages).serializable_hash[:data].map { |message| message[:attributes] }
  end

  # GET /applications/:application_token/chats/:chat_number/messages/:number
  def show
    render json: MessageSerializer.new(@message).serializable_hash[:data][:attributes]
  end

  # POST /applications/:application_token/chats/:chat_number/messages
  def create
    message_number = @chat.messages.maximum(:number).to_i + 1

    @message = @chat.messages.build(message_params.merge(number: message_number))

    if @message.save
      render json: { number: @message.number }, status: :created
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # PUT/PATCH /applications/:application_token/chats/:chat_number/messages/:number
  def update
    retries = 0

    begin
      # Attempt to update the message
      if @message.update(message_params)
        render json: MessageSerializer.new(@message).serializable_hash[:data][:attributes]
      else
        render json: @message.errors, status: :unprocessable_entity
      end
    rescue ActiveRecord::StaleObjectError
      # If there's a version conflict, log and retry
      Rails.logger.info "Retrying update for message in chat ##{@chat.number}, attempt ##{retries + 1}"

      retries += 1
      if retries <= Rails.configuration.max_retries
        # Reload the message and retry the update
        @message.reload
        retry
      else
        # If maximum retries exceeded, respond with a conflict error
        render json: { error: "Conflict detected. The message was updated by another process. Please try again." }, status: :conflict
      end
    end
  end

  # GET /applications/:application_token/chats/:chat_number/messages/search?query=your_query
  def search
    if params[:query].blank?
      render json: { error: "Search query cannot be blank" }, status: :bad_request
      return
    end

    results = Message.search_in_chat(params[:query], @chat.id)
    render json: MessageSerializer.new(results).serializable_hash[:data].map { |result| result[:attributes] }
  end

  private

  # Set the application based on the token
  def set_application
    @application = Application.find_by!(token: params[:application_token])
  end

  # Set the chat based on the chat number within an application
  def set_chat
    @chat = @application.chats.find_by!(number: params[:chat_number])
  end

  # Set the message based on the message number within a chat
  def set_message
    @message = @chat.messages.find_by!(number: params[:number])
  end

  # Strong parameters for message creation
  def message_params
    params.require(:message).permit(:body)
  end
end
