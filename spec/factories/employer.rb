FactoryBot.define do
  factory :employer do
    company { create(:company) }
    email { Faker::Internet.unique.safe_email }
    role { "super_admin" }

    trait :with_password do
      password { Faker::Internet.password }
    end
  end
end
