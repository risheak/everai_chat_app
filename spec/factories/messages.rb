FactoryBot.define do
  factory :message do
    archived { [true, false].sample }
    body { Faker::Lorem.sentence }
    association :profile
    sent_by { %w[user profile].sample }
  end
end
