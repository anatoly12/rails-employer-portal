FactoryBot.define do
  factory :employee_tag do
    company { create :company }
    name { Faker::Lorem.word }
  end
end
