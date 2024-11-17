# spec/routing/chat_routing_spec.rb
require 'rails_helper'

RSpec.describe "Chat routing", type: :routing do
  it "routes to #index" do
    expect(get: "/applications/:token/chats").to route_to("chats#index", application_token: ":token")
  end

  it "routes to #show" do
    expect(get: "/applications/:token/chats/:number").to route_to("chats#show", application_token: ":token", number: ":number")
  end

  it "routes to #create" do
    expect(post: "/applications/:token/chats").to route_to("chats#create", application_token: ":token")
  end

  it "routes to #search" do
    expect(get: "/applications/:token/chats/:number/messages/search").to route_to("messages#search", application_token: ":token", chat_number: ":number")
  end
end
