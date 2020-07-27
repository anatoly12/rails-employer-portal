FactoryBot.define do
  factory :company do
    name { Faker::Company.unique.name }
    plan { create :plan }
    remote_id { -1 }
  end
end
