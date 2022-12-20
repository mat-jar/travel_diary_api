FactoryBot.define do
  factory :entry do
    title { Faker::Lorem.words }
    note { Faker::Lorem.paragraph }
    place { Faker::Lorem.words }
    weather { Faker::Lorem.words }
  end
  factory :user do
    email { Faker::Internet.email}
    uid {Faker::Internet.uuid}
    provider {"google_oauth2"}
  end

end
