FactoryBot.define do
  factory :sync_access_code, class: "EmployerPortal::Sync::AccessCode" do
    partner { create :sync_partner }
    access_code { Faker::Internet.uuid }
  end
end
