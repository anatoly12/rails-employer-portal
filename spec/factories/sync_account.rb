FactoryBot.define do
  factory :sync_account, class: "EmployerPortal::Sync::Account" do
    user { create :sync_user }
    email { Faker::Internet.unique.safe_email }
  end
end
