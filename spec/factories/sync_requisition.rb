FactoryBot.define do
  factory :sync_requisition, class: "EmployerPortal::Sync::Requisition" do
    user { create :sync_user }
  end
end
