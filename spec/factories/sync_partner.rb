FactoryBot.define do
  factory :sync_partner, class: "EmployerPortal::Sync::Partner" do
    name { Faker::Company.unique.name }
    type_of { "CONSUMER" }
  end
end
