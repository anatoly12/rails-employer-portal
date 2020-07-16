require "rails_helper"

RSpec.describe ::EmployerPortal::Query::Employee do
  let(:admin_user) { create :admin_user }
  let(:context) { ::EmployerPortal::Context.new account_id: admin_user.id, section: :admin }
  subject { described_class.new context }

  describe "#search_dataset" do
    let(:filters) { {} }
    let(:sort_order) { "created_at:asc" }

    context "when sync is NOT connected" do
      context "filtering" do
        let!(:employee1) { create :employee }
        let!(:employee2) { create :employee, remote_id: 1 }

        context "by company id" do
          let(:filters) { { "company_id_equals" => employee1.company.id.to_s } }

          it "returns only the matching employees" do
            res = subject.search_dataset(filters, sort_order).all
            expect(res.map(&:id)).to eql [employee1.id]
            expect(res[0]).to be_kind_of(Employee)
          end
        end

        context "by full name" do
          let(:filters) { { "full_name_contains" => "#{employee2.first_name} #{employee2.last_name}" } }

          it "returns only the matching employees" do
            res = subject.search_dataset(filters, sort_order).all
            expect(res.map(&:id)).to eql [employee2.id]
            expect(res[0]).to be_kind_of(Employee)
          end
        end

        context "by email" do
          let(:filters) { { "email_contains" => employee1.email } }

          it "returns only the matching employees" do
            res = subject.search_dataset(filters, sort_order).all
            expect(res.map(&:id)).to eql [employee1.id]
            expect(res[0]).to be_kind_of(Employee)
          end
        end

        context "by sync status" do
          it "returns only the matching employees" do
            res = subject.search_dataset({ "sync_status_equals" => "1" }, sort_order).all
            expect(res.map(&:id)).to eql [employee2.id]
            expect(res[0]).to be_kind_of(Employee)
            res = subject.search_dataset({ "sync_status_equals" => "0" }, sort_order).all
            expect(res.map(&:id)).to eql [employee1.id]
            expect(res[0]).to be_kind_of(Employee)
          end
        end

        context "by daily checkup status" do
          let(:filters) { { "daily_checkup_status_equals" => "Cleared" } }

          it "returns ALL employees" do
            res = subject.search_dataset(filters, sort_order).all
            expect(res.map(&:id)).to eql [employee1.id, employee2.id]
          end
        end

        context "by daily checkup status" do
          let(:filters) { { "testing_status_equals" => "Cleared" } }

          it "returns ALL employees" do
            res = subject.search_dataset(filters, sort_order).all
            expect(res.map(&:id)).to eql [employee1.id, employee2.id]
          end
        end
      end

      context "sorting" do
        let!(:employee1) { create :employee, first_name: "Bob", last_name: "Aaron", state: "NY", email: "bob@example.org" }
        let!(:employee2) { create :employee, first_name: "Alice", last_name: "Bayer", state: "AL", email: "alice@example.org" }

        it { is_expected.to be_sortable("first_name", [employee2, employee1]) }
        it { is_expected.to be_sortable("last_name", [employee1, employee2]) }
        it { is_expected.to be_sortable("full_name", [employee2, employee1]) }
        it { is_expected.to be_sortable("email", [employee2, employee1]) }
        it { is_expected.to be_sortable("state", [employee2, employee1]) }
        it { is_expected.to be_sortable("checkup", [employee1, employee2]) }
        it { is_expected.to be_sortable("checkup_updated_at", [employee1, employee2]) }
        it { is_expected.to be_sortable("testing", [employee1, employee2]) }
        it { is_expected.to be_sortable("testing_updated_at", [employee1, employee2]) }
        it { is_expected.to be_sortable("created_at", [employee1, employee2]) }
      end
    end

    context "when sync is connected", type: :sync do
      before { with_sync_connected }

      context "filtering" do
        let!(:employee1) { create :employee }
        let!(:employee2) { create :employee, remote_id: 1 }

        context "by daily checkup status" do
          let(:filters) { { "daily_checkup_status_equals" => "Cleared" } }

          it "returns only the matching employees" do
            expect(subject.search_dataset(filters, sort_order).all).to be_empty
          end
        end

        context "by daily checkup status" do
          let(:filters) { { "testing_status_equals" => "Cleared" } }

          it "returns only the matching employees" do
            expect(subject.search_dataset(filters, sort_order).all).to be_empty
          end
        end
      end

      context "sorting" do
        let(:now) { Time.now }
        let(:today) { now.to_date }
        let(:passport_product) { create :sync_passport_product }
        let(:plan) { create :plan, remote_id: passport_product.pk }
        let(:company) { create :company, plan: plan }
        let(:employee1) { create :employee, company: company }
        let(:employee2) { create :employee, company: company }
        before do
          ::EmployerPortal::Sync.create_partner_for_company! company
          ::EmployerPortal::Sync.create_account_for_employee! employee1
          ::EmployerPortal::Sync::Covid19DailyCheckupStatus.find_or_create(
            daily_checkup_status_code: 2,
          ) { |status| status.daily_checkup_status = "Not Cleared" }
          ::EmployerPortal::Sync::Covid19DailyCheckup.create(
            account_id: employee1.remote_id,
            daily_checkup_status_code: 2,
            checkup_date: today,
          )
          ::EmployerPortal::Sync::Covid19Evaluation.create(
            account_id: employee1.remote_id,
            status: 2,
            updated_at: now,
          )
        end

        it { is_expected.to be_sortable("checkup", [employee2, employee1]) }
        it { is_expected.to be_sortable("checkup_updated_at", [employee2, employee1]) }
        it { is_expected.to be_sortable("testing", [employee2, employee1]) }
        it { is_expected.to be_sortable("testing_updated_at", [employee2, employee1]) }
      end
    end
  end
end
