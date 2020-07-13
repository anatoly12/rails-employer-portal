FactoryBot.define do
  factory :sync_t_question, class: "EmployerPortal::Sync::TQuestion" do
    question { Faker::Lorem.sentence }
    data_type { create :sync_data_type }
  end
end
