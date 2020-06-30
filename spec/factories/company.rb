FactoryBot.define do
  factory :company do
    name { Faker::Company.name }
    plan { "billed_by_invoice" }
    remote_id { -1 }
  end
end
