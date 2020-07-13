FactoryBot.define do
  factory :sync_data_type, class: "EmployerPortal::Sync::DataType" do
    name { Faker::Commerce.product_name }
    type_of { "LIST_OPT" }
    list { create :sync_list, :with_items }
  end
end
