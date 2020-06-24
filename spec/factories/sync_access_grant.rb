FactoryBot.define do
  factory :sync_access_grant, class: "EmployerPortal::Sync::AccessGrant" do
    account { create :account }
    access_code { create :access_code }
  end
end
