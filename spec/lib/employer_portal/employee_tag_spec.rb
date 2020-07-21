require "rails_helper"

RSpec.describe ::EmployerPortal::EmployeeTag do
  describe ".whitelist" do
    let(:company) { create :company }
    let(:context) { double :context, company_id: company.id }
    subject { described_class.whitelist context }

    context "without tag" do
      it "is empty" do
        expect(subject).to be_empty
      end
    end

    context "with an unused tag" do
      let!(:tag) { create :employee_tag }

      it "is empty" do
        expect(subject).to be_empty
      end
    end

    context "with a tag in use but from another company" do
      let(:employee) { create :employee }
      let(:tag) { create :employee_tag }
      let!(:tagging) { create :employee_tagging, employee: employee, tag: tag }

      it "is empty" do
        expect(subject).to be_empty
      end
    end

    context "with a tag in use" do
      let(:employee) { create :employee }
      let(:tag) { create :employee_tag, company: company }
      let!(:tagging) { create :employee_tagging, employee: employee, tag: tag }

      it "equals the tag name" do
        expect(subject).to eql [tag.name]
      end
    end

    context "with multiple tags" do
      let(:tag1) { create :employee_tag, name: "Team D" }
      let(:tag2) { create :employee_tag, name: "Team C", company: company }
      let(:tag3) { create :employee_tag, name: "Team B", company: company }
      let(:tag4) { create :employee_tag, name: "Team A", company: company }
      let!(:tagging1) { create :employee_tagging, tag: tag1, employee: create(:employee) }
      let!(:tagging2) { create :employee_tagging, tag: tag3, employee: create(:employee) }
      let!(:tagging3) { create :employee_tagging, tag: tag4, employee: create(:employee) }

      it "is sorted by name" do
        expect(subject).to eql [tag4.name, tag3.name]
      end

      it "is sorted by employee count" do
        create :employee_tagging, tag: tag3, employee: create(:employee)
        expect(subject).to eql [tag3.name, tag4.name]
      end
    end
  end
end
