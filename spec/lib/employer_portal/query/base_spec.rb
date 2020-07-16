require "rails_helper"

RSpec.describe ::EmployerPortal::Query::Base do
  let(:context) { double :context }
  subject { described_class.new context }

  describe "#search_dataset" do
    let(:filters) { {} }
    let(:sort_order) { "created_at:asc" }

    it "raises an error because #dataset isn't implemented" do
      expect do
        subject.search_dataset filters, sort_order
      end.to raise_error(NotImplementedError, "EmployerPortal::Query::Base#dataset")
    end

    context "on a subclass with dataset implemented" do
      let :klass do
        Class.new(described_class) do
          def dataset; end
        end
      end
      subject { klass.new context }

      context "without filter" do
        it "raises an error because #apply_order isn't implemented" do
          expect do
            subject.search_dataset filters, sort_order
          end.to raise_error(NotImplementedError, /#apply_order/)
        end
      end

      context "with filters" do
        let(:filters) { { "full_name_contains" => "a" } }

        it "raises an error because #apply_filter isn't implemented" do
          expect do
            subject.search_dataset filters, sort_order
          end.to raise_error(NotImplementedError, /#apply_filter/)
        end
      end
    end
  end
end
