FactoryBot.define do
  factory :plan do
    name { Faker::Commerce.product_name }
    billed_by { "invoice" }
    daily_checkup_enabled { true }
    testing_enabled { true }
    health_passport_enabled { true }
    employer_limit { 0 }
    employee_limit { 0 }
  end
end
