FactoryBot.define do
  factory :profile do
    name { Faker::Name.name }
    category { %w[realistic anime].sample }
    gender { %w[male female].sample }
  end
end
