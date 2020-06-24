FactoryBot.define do
  factory :sync_kit, class: "EmployerPortal::Sync::Kit" do
    t_kit { create :sync_t_kit }
    requisition { create :sync_requisition }
    partner { create :sync_partner }
    barcode { Faker::Code.isbn }
  end
end
