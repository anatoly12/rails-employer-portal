FactoryBot.define do
  factory :sync_passport_product, class: "EmployerPortal::Sync::PassportProduct" do
    name { Faker::Commerce.product_name }
    t_kit { create :sync_t_kit }
  end
end
