require "rails_helper"

RSpec.describe ::EmployerPortal::Query::SymptomLog do
  let(:company) { create :company }
  let(:employer) { create :employer, company: company }
  let(:employee) { create :employee, company: company }
  let(:context) { ::EmployerPortal::Context.new account_id: employer.id, section: :application }
  subject { described_class.new context, employee }

  describe "#search_dataset" do
    let(:filters) { {} }
    let(:sort_order) { "created_at:asc" }

    context "when sync is NOT connected" do
      it "raises an error" do
        expect do
          subject.search_dataset(filters, sort_order).all
        end.to raise_error Sequel::DatabaseError
      end
    end

    context "when sync is connected", type: :sync do
      before { with_sync_connected }

      context "without logs" do
        it "is empty" do
          expect(subject.search_dataset(filters, sort_order).all).to be_empty
        end
      end

      context "with a few logs" do
        include ActiveSupport::Testing::TimeHelpers
        let(:now) { Time.now }
        let(:today) { now.to_date }
        let(:passport_product) { create :sync_passport_product }
        let(:plan) { create :plan, remote_id: passport_product.pk }
        let(:company) { create :company, plan: plan }
        let(:account) { ::EmployerPortal::Sync::Account[employee.remote_id] }
        let(:user) { ::EmployerPortal::Sync::User[account.user_id] }
        let(:kit) { create :sync_kit, requisition: user.requisitions.first }
        before do
          ::EmployerPortal::Sync.create_partner_for_company! company
          ::EmployerPortal::Sync.create_account_for_employee! employee
          travel_to now - 1.day do
            create :sync_question, kit: kit, sub_group: "Symptoms", response: "Yes"
            create :sync_question, kit: kit, question: "Temperature", response: "99.5ºF"
          end
          travel_to now do
            create :sync_question, kit: kit, question: "Temperature", response: "100.4ºF"
          end
        end

        context "filtering" do
          context "by date" do
            let(:filters) { { "date_equals" => today.to_s } }

            it "returns only the matching logs" do
              res = subject.search_dataset(filters, sort_order).all
              expect(res.map(&:log_date)).to eql [today]
              expect(res[0]).to be_kind_of(SymptomLog)
            end
          end
        end
      end
    end
  end
end
