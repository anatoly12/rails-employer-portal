FactoryBot.define do
  factory :sync_t_kit, class: "EmployerPortal::Sync::TKit" do
    name { Faker::Commerce.product_name }
  end
end
