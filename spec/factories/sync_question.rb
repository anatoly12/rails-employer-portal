FactoryBot.define do
  factory :sync_question, class: "EmployerPortal::Sync::Question" do
    t_question { create :sync_t_question }
    question { Faker::Lorem.sentence }
    kit { create :sync_kit }
    data_type { create :sync_data_type }
  end
end
