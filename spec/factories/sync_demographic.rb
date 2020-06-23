FactoryBot.define do
  factory :sync_demographic, class: "EmployerPortal::Sync::AccountDemographic" do
    account { create :account }
    full_legal_name { Faker::Name.name }
    state_of_residence { Faker::Address.state_abbr }
    phone_number { Faker::PhoneNumber.phone_number }
  end
end
