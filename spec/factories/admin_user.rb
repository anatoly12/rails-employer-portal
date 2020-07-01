FactoryBot.define do
  factory :admin_user do
    email { Faker::Internet.unique.safe_email }
    password { Faker::Internet.password }
  end
end
