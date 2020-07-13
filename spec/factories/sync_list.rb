FactoryBot.define do
  factory :sync_list, class: "EmployerPortal::Sync::List" do
    name { Faker::Commerce.product_name }

    trait :with_items do
      after(:create) do |list|
        FactoryBot.create :sync_list_item, list: list, item: "Yes"
        FactoryBot.create :sync_list_item, list: list, item: "No"
        FactoryBot.create :sync_list_item, list: list, item: "Don't Know"
      end
    end
  end
end
