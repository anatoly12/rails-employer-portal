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
  end
end
