FactoryBot.define do
  factory :message do
    body { Faker::Lorem.sentence(word_count: 10) }
    number { Faker::Number.unique.number(digits: 5) }

    association :chat
  end
end
