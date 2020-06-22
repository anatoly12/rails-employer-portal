FactoryBot.define do
  factory :zip_code do
    transient do
      lat { Faker::Address.latitude }
      long { Faker::Address.longitude }
      point { "POINT(#{lat} #{long})" }
    end

    zip { Faker::Address.unique.zip_code }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    geopoint { Sequel.function(:GeomFromText, point) }

    trait :new_york do
      zip { "10001" }
      city { "New York" }
      state { "NY" }
      geopoint { Sequel.function(:GeomFromText, "POINT(40.750742 -73.99653)") }
    end
  end
end
