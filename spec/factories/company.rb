FactoryBot.define do
  factory :company do
    name { Faker::Company.unique.name }
    plan { create :plan }
  end
end
