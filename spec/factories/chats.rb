FactoryBot.define do
  factory :chat do
    number { Faker::Number.unique.number(digits: 5) }
    messages_count { 0 }

    association :application

    after(:build) do |chat|
      Redis.current.set("chat:#{chat.id}:messages_max_number", 0)
    end
  end
end
