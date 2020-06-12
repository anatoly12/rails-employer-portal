FactoryBot.define do
  factory :company do
    name { Faker::Company.name }
    plan { "billed_by_invoice" }
  end
end
