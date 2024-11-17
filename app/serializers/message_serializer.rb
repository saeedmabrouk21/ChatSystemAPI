# app/serializers/message_serializer.rb
class MessageSerializer
  include JSONAPI::Serializer
  attributes :number, :body
end
