require "rails_helper"

RSpec.describe ::EmployerPortal::Query::AdminUser do
  let(:context) { double :context }
  subject { described_class.new context }

  describe "#search_dataset" do
    let(:filters) { {} }
    let(:sort_order) { "created_at:asc" }

    context "filtering" do
      let!(:admin_user1) { create :admin_user }
      let!(:admin_user2) { create :admin_user }
      let(:filters) { { "email_contains" => admin_user1.email.to_s } }

      it "raises an error" do
        expect do
          subject.search_dataset(filters, sort_order).all
        end.to raise_error(NotImplementedError, "EmployerPortal::Query::AdminUser#apply_filter")
      end
    end

    context "sorting" do
      let!(:admin_user1) { create :admin_user, email: "bob@example.org" }
      let!(:admin_user2) { create :admin_user, email: "alice@example.org" }

      it { is_expected.to be_sortable("email", [admin_user2, admin_user1]) }
      it { is_expected.to be_sortable("created_at", [admin_user1, admin_user2]) }
    end
  end
end
