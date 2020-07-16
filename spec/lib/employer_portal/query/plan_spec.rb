require "rails_helper"

RSpec.describe ::EmployerPortal::Query::Plan do
  let(:context) { double :context }
  subject { described_class.new context }

  describe "#search_dataset" do
    let(:filters) { {} }
    let(:sort_order) { "created_at:asc" }

    context "filtering" do
      let!(:plan1) { create :plan }
      let!(:plan2) { create :plan }

      context "by name" do
        let(:filters) { { "name_contains" => plan1.name.to_s } }

        it "returns only the matching plans" do
          res = subject.search_dataset(filters, sort_order).all
          expect(res.map(&:id)).to eql [plan1.id]
          expect(res[0]).to be_kind_of(Plan)
        end
      end
    end

    context "sorting" do
      let!(:plan1) { create :plan, name: "Plan B" }
      let!(:plan2) { create :plan, name: "Plan A" }

      it { is_expected.to be_sortable("name", [plan2, plan1]) }
      it { is_expected.to be_sortable("created_at", [plan1, plan2]) }
    end
  end
end
