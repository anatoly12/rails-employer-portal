require "rails_helper"

describe AdminHelper do
  describe "#gravatar" do
    subject { helper.gravatar(context) }

    context "when current context has no account" do
      let(:context) { ::EmployerPortal::Context.new(account_id: nil, section: :application) }

      it "raises an error" do
        expect{ subject }.to raise_error NoMethodError, /undefined method `email'/
      end
    end

    context "when current context has an email" do
      let(:employer) { create :employer, email: "bob@example.com" }
      let(:context) { ::EmployerPortal::Context.new(account_id: employer.id, section: :application) }

      it "raises an error" do
        expect( subject ).to eql "https://www.gravatar.com/avatar/4b9bb80620f03eb3719e0a061c14283d?d=wavatar&r=pg"
      end
    end
  end

  describe "#label_class" do
    subject { helper.label_class.split " " }

    it { is_expected.to contain_exactly "block", "text-gray-700", "text-sm", "font-bold", "mb-2", "select-none" }
  end

  describe "#current_controller?" do
    subject { helper.current_controller?(new_admin_company_path(page: 2)) }
    before { allow(helper).to receive(:controller_path).and_return controller_path }

    describe "when controller path doesn't match" do
      let(:controller_path) { "admin/employees" }

      it { is_expected.to be false }
    end

    describe "when controller path matches" do
      let(:controller_path) { "admin/companies" }

      it { is_expected.to be true }
    end
  end
end
