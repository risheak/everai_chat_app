Server.create(name: 'Server1', url: 'http://34.36.42.74/api/v1/chat')
Server.create(name: 'Server2', url: 'http://34.36.42.74/api/v1/chat')

number_of_profiles = 100000

ActiveRecord::Base.transaction do
  number_of_profiles.times do
    Profile.create(
      name: Faker::Name.name,
      category: Profile.categories.keys.sample,
      gender: Profile.genders.keys.sample
    )
  end
end
