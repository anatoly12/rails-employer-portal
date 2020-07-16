require "rails_helper"

RSpec.describe ::EmployerPortal::Query::EmailTemplate do
  let(:context) { double :context }
  subject { described_class.new context }

  describe "#search_dataset" do
    let(:filters) { {} }
    let(:sort_order) { "created_at:asc" }

    context "filtering" do
      let!(:email_template1) { create :email_template, :with_plan }
      let!(:email_template2) { create :email_template, :with_plan }

      context "by name" do
        let(:filters) { { "name_contains" => email_template1.name.to_s } }

        it "returns only the matching email_templates" do
          res = subject.search_dataset(filters, sort_order).all
          expect(res.map(&:id)).to eql [email_template1.id]
          expect(res[0]).to be_kind_of(EmailTemplate)
        end
      end

      context "by plan id" do
        let(:filters) { { "plan_id_equals" => email_template2.plan.id.to_s } }

        it "returns only the matching email_templates" do
          res = subject.search_dataset(filters, sort_order).all
          expect(res.map(&:id)).to eql [email_template2.id]
          expect(res[0]).to be_kind_of(EmailTemplate)
        end
      end
    end

    context "sorting" do
      let!(:email_template1) { create :email_template, name: "Email template B" }
      let!(:email_template2) { create :email_template, name: "Email template A" }

      it { is_expected.to be_sortable("name", [email_template2, email_template1]) }
      it { is_expected.to be_sortable("created_at", [email_template1, email_template2]) }
    end
  end
end
