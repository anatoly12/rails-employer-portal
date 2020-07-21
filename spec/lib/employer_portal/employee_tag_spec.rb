require "rails_helper"

RSpec.describe ::EmployerPortal::EmployeeTag do
  describe ".whitelist" do
    let(:company) { create :company }
    let(:employer) { create :employer, company: company }
    let(:context) { ::EmployerPortal::Context.new account_id: employer.id, section: :application }
    subject { described_class.whitelist context }

    context "when employer is allowed all employee tags" do
      context "without tag" do
        it "is empty" do
          expect(subject).to be_empty
        end
      end

      context "with tags" do
        let(:from_another_company) { create :employee_tag, name: "Team D" }
        let!(:unused) { create :employee_tag, name: "Team C", company: company }
        let(:used1) { create :employee_tag, name: "Team B", company: company }
        let(:used2) { create :employee_tag, name: "Team A", company: company }
        let!(:tagging1) { create :employee_tagging, tag: from_another_company, employee: create(:employee) }
        let!(:tagging2) { create :employee_tagging, tag: used1, employee: create(:employee) }
        let!(:tagging3) { create :employee_tagging, tag: used2, employee: create(:employee) }

        it "is sorted by name" do
          expect(subject).to eql [used2.name, used1.name, unused.name]
        end

        it "is sorted by employee count" do
          create :employee_tagging, tag: used1, employee: create(:employee)
          expect(subject).to eql [used1.name, used2.name, unused.name]
        end
      end
    end

    context "when employer is allowed only some employee tags" do
      let(:from_another_company) { create :employee_tag, name: "Team D" }
      let!(:unused) { create :employee_tag, name: "Team C", company: company }
      let(:used1) { create :employee_tag, name: "Team B", company: company }
      let(:used2) { create :employee_tag, name: "Team A", company: company }
      let!(:tagging1) { create :employee_tagging, tag: from_another_company, employee: create(:employee) }
      let!(:tagging2) { create :employee_tagging, tag: used1, employee: create(:employee) }
      let!(:tagging3) { create :employee_tagging, tag: used2, employee: create(:employee) }
      let(:employer) { create :employer, company: company, allowed_all_employee_tags: false, allowed_employee_tags: [used1.id, used2.id] }

      it "returns only allowed tag names" do
        expect(subject).to eql [used2.name, used1.name]
      end
    end
  end
end
