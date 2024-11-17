# spec/routing/messages_routing_spec.rb
require 'rails_helper'

RSpec.describe "Messages routing", type: :routing do
  it "routes to #index" do
    expect(get: "/applications/:token/chats/:number/messages").to route_to("messages#index", application_token: ":token", chat_number: ":number")
  end

  it "routes to #show" do
    expect(get: "/applications/:token/chats/:number/messages/:number").to route_to("messages#show", application_token: ":token", chat_number: ":number", number: ":number")
  end

  it "routes to #create" do
    expect(post: "/applications/:token/chats/:number/messages").to route_to("messages#create", application_token: ":token", chat_number: ":number")
  end

  it "routes to #update" do
    expect(put: "/applications/:token/chats/:number/messages/:number").to route_to("messages#update", application_token: ":token", chat_number: ":number", number: ":number")
  end

  it "routes to #search" do
    expect(get: "/applications/:token/chats/:number/messages/search").to route_to("messages#search", application_token: ":token", chat_number: ":number")
  end
end
