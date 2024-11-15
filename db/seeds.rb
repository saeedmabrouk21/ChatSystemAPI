# db/seeds.rb

# Create applications
app1 = Application.create(name: "Application 1", token: "token 1")
app2 = Application.create(name: "Application 2", token: "token 2")

# Output any errors if applications are not created successfully
puts app1.errors.full_messages unless app1.persisted?
puts app2.errors.full_messages unless app2.persisted?

# Create chats for each application
chat1 = Chat.create(application_id: app1.id, number: 1, messages_count: 2)
chat2 = Chat.create(application_id: app1.id, number: 2, messages_count: 1)
chat3 = Chat.create(application_id: app2.id, number: 1, messages_count: 3)

# Output any errors if chats are not created successfully
puts chat1.errors.full_messages unless chat1.persisted?
puts chat2.errors.full_messages unless chat2.persisted?
puts chat3.errors.full_messages unless chat3.persisted?

# Create messages for the chats
Message.create(chat_id: chat1.id, number: 1, body: "Hello from Chat 1 in Application 1")
Message.create(chat_id: chat1.id, number: 2, body: "Hi, this is another message in Chat 1")
Message.create(chat_id: chat2.id, number: 1, body: "Message in Chat 2 of Application 1")
Message.create(chat_id: chat3.id, number: 1, body: "First message in Chat 3 of Application 2")
Message.create(chat_id: chat3.id, number: 2, body: "Another message in Chat 3 of Application 2")
Message.create(chat_id: chat3.id, number: 3, body: "Another message in Chat 3 of Application 2")
