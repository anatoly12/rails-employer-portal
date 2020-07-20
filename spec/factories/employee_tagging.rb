FactoryBot.define do
  factory :employee_tagging do
    employee { create :employee }
    tag { create :employee_tag }
  end
end
