FactoryBot.define do
  factory :application do
    name { "Test Application" }
    token { SecureRandom.hex(10) }

    after(:create) do |application|
      Redis.current.set("application:#{application.id}:chats_max_number", 0)
    end
  end
end
