FactoryBot.define do
  factory :company do
    name { Faker::Company.name }
    plan { "unlimited" }
  end
end
