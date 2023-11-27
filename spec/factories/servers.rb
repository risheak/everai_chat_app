# spec/factories/servers.rb

FactoryBot.define do
  factory :server do
    sequence(:name) { |n| "Server-#{n}" }
    url { 'http://34.36.42.74/api/v1/chat' } # Update with the actual URL
  end
end
