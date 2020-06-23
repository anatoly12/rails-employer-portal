FactoryBot.define do
  factory :sync_user, class: "EmployerPortal::Sync::User" do
    email { Faker::Internet.unique.safe_email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
  end
end
