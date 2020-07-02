FactoryBot.define do
  factory :company do
    name { Faker::Company.name }
    plan { create :plan }
    remote_id { -1 }
  end
end
