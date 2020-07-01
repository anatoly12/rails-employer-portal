FactoryBot.define do
  factory :employer do
    company { create(:company) }
    email { Faker::Internet.unique.safe_email }
    password { Faker::Internet.password }
    role { "super_admin" }
  end
end
