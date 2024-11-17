# app/serializers/chat_serializer.rb
class ChatSerializer
  include JSONAPI::Serializer

  attributes :number, :messages_count
end
