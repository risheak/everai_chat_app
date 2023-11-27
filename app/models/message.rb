class Message < ApplicationRecord
  belongs_to :profile

  enum sent_by: { user: 0, profile: 1 }
end
