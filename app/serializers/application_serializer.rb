# app/serializers/application_serializer.rb
class ApplicationSerializer
  include JSONAPI::Serializer
  attributes :token, :chats_count
end
