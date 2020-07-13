FactoryBot.define do
  factory :sync_list_item, class: "EmployerPortal::Sync::ListItem" do
    list { create :sync_list }
    item { Faker::Lorem.word }
    description { "" }
  end
end
