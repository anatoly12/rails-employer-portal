FactoryBot.define do
  factory :sync_covid19_message_code, class: "EmployerPortal::Sync::Covid19MessageCode" do
    message_subject { Faker::Marketing.buzzwords }
    message_copy { Faker::Lorem.paragraph }
  end
end
