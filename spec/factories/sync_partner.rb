FactoryBot.define do
  factory :sync_partner, class: "EmployerPortal::Sync::Partner" do
    name { Faker::Company.name }
    type_of { "CONSUMER" }
  end
end
