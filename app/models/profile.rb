class Profile < ApplicationRecord
  enum gender: { male: 0, female: 1 }
  enum category: { anime: 0, realistic: 1 }

  has_many :messages
end
