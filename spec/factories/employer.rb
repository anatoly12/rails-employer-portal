FactoryBot.define do
  factory :employer do
    company { create :company }
    role { "super_admin" }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.unique.safe_email }
    password { Faker::Internet.password }
    allowed_to_add_employees { true }
    allowed_to_add_employee_tags { true }
    allowed_all_employee_tags { true }
    allowed_employee_tags { [] }
  end
end
