require "rails_helper"

RSpec.describe ::EmployerPortal::Query::Employer do
  subject { described_class.new context }

  describe "#search_dataset" do
    let(:filters) { {} }
    let(:sort_order) { "created_at:asc" }

    context "when context is application" do
      let(:employer) { create :employer }
      let(:context) { ::EmployerPortal::Context.new account_id: employer.id, section: :application }

      it "raises an error" do
        expect do
          subject.search_dataset(filters, sort_order).all
        end.to raise_error(ArgumentError, "unsupported section")
      end
    end

    context "when context is admin" do
      let(:admin_user) { create :admin_user }
      let(:context) { ::EmployerPortal::Context.new account_id: admin_user.id, section: :admin }

      context "filtering" do
        let!(:employer1) { create :employer }
        let!(:employer2) { create :employer }

        context "by company" do
          let(:filters) { { "company_id_equals" => employer1.company.id.to_s } }

          it "returns only the matching employers" do
            res = subject.search_dataset(filters, sort_order).all
            expect(res.map(&:id)).to eql [employer1.id]
            expect(res[0]).to be_kind_of(Employer)
          end
        end

        context "by full name" do
          let(:filters) { { "full_name_contains" => "#{employer2.first_name} #{employer2.last_name}" } }

          it "returns only the matching employers" do
            res = subject.search_dataset(filters, sort_order).all
            expect(res.map(&:id)).to eql [employer2.id]
            expect(res[0]).to be_kind_of(Employer)
          end
        end

        context "by email" do
          let(:filters) { { "email_contains" => employer1.email } }

          it "returns only the matching employers" do
            res = subject.search_dataset(filters, sort_order).all
            expect(res.map(&:id)).to eql [employer1.id]
            expect(res[0]).to be_kind_of(Employer)
          end
        end
      end

      context "sorting" do
        let!(:employer1) { create :employer, first_name: "Bob", last_name: "Aaron", email: "bob@example.org" }
        let!(:employer2) { create :employer, first_name: "Alice", last_name: "Bayer", email: "alice@example.org" }

        it { is_expected.to be_sortable("first_name", [employer2, employer1]) }
        it { is_expected.to be_sortable("last_name", [employer1, employer2]) }
        it { is_expected.to be_sortable("full_name", [employer2, employer1]) }
        it { is_expected.to be_sortable("email", [employer2, employer1]) }
      end
    end
  end
end
