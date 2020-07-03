FactoryBot.define do
  factory :email_log do
    email_template { create :email_template }
    company { create :company }
    employer { create :employer }
    employee { create :employee }
    trigger_key { "employee_new" }
    from { "Customer Support <#{Faker::Internet.safe_email}>" }
    recipient { Faker::Internet.safe_email }
    subject { Faker::Marketing.buzzwords }
    html { "<p>#{Faker::Lorem.paragraph}</p>" }
    text { Faker::Lorem.paragraph }
  end
end
