FactoryBot.define do
  factory :email_template do
    name { |i| "Template #{i}" }
    trigger_key { EmailTemplate::TRIGGER_EMPLOYEE_NEW }
    from { "Customer Support <#{Faker::Internet.safe_email}>" }
    subject { Faker::Marketing.buzzwords }
    html { Faker::Lorem.paragraph }
    text { Faker::Lorem.paragraph }
  end
end
