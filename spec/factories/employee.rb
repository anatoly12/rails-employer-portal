FactoryBot.define do
  factory :employee do
    company { create :company }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.unique.safe_email }
    phone { Faker::PhoneNumber.phone_number }
    state { Faker::Address.state_abbr }

    trait :with_zipcode do
      state { nil }
      zipcode { create(:zip_code).zip }
    end
  end
end
