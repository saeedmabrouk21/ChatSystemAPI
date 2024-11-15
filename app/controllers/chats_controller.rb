  class ChatsController < ApplicationController
    before_action :set_application
    before_action :set_chat, only: [ :show ]

    # GET /applications/:application_token/chats
    def index
      @chats = @application.chats.order(:number)
      render json: @chats
    end

    # GET /applications/:application_token/chats/:number
    def show
      render json: @chat
    end

    # POST /applications/:application_token/chats
    def create
      chat_number = @application.chats.maximum(:number).to_i + 1

      @chat = @application.chats.build(number: chat_number)

      if @chat.save
        render json: { number: @chat.number }, status: :created
      else
        render json: @chat.errors, status: :unprocessable_entity
      end
    end

    private

    # Set the application based on the token
    def set_application
      @application = Application.find_by!(token: params[:application_token])
    end

    # Set the chat based on the chat number within an application
    def set_chat
      @chat = @application.chats.find_by!(number: params[:number])
    end
  end
