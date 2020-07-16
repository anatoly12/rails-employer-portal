require "rails_helper"

RSpec.describe ::EmployerPortal::Query::Company do
  let(:context) { double :context }
  subject { described_class.new context }

  describe "#search_dataset" do
    let(:filters) { {} }
    let(:sort_order) { "created_at:asc" }

    context "filtering" do
      let!(:company1) { create :company }
      let!(:company2) { create :company }

      context "by plan" do
        let(:filters) { { "plan_id_equals" => company1.plan.id.to_s } }

        it "returns only the matching companys" do
          res = subject.search_dataset(filters, sort_order).all
          expect(res.map(&:id)).to eql [company1.id]
          expect(res[0]).to be_kind_of(Company)
        end
      end

      context "by name" do
        let(:filters) { { "name_contains" => company2.name.to_s } }

        it "returns only the matching companys" do
          res = subject.search_dataset(filters, sort_order).all
          expect(res.map(&:id)).to eql [company2.id]
          expect(res[0]).to be_kind_of(Company)
        end
      end
    end

    context "sorting" do
      let!(:company1) { create :company, name: "Company B" }
      let!(:company2) { create :company, name: "Company A" }

      it { is_expected.to be_sortable("name", [company2, company1]) }
      it { is_expected.to be_sortable("created_at", [company1, company2]) }
    end
  end
end
