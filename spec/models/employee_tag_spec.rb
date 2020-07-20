require "rails_helper"

RSpec.describe EmployeeTag, type: :model do
  subject { build :employee_tag }

  it "can be saved" do
    expect(subject).to be_valid
    subject.save
  end

  context "validations" do
    it "requires company_id" do
      subject.company_id = nil
      expect(subject).not_to be_valid
      expect(subject.errors).to eql company_id: ["is not present"]
    end

    it "requires name" do
      subject.name = nil
      expect(subject).not_to be_valid
      expect(subject.errors).to eql name: ["is not present"]
    end

    it "checks that name is unique within the company" do
      create :employee_tag, name: subject.name
      expect(subject).to be_valid
      create :employee_tag, company: subject.company, name: subject.name
      expect(subject).not_to be_valid
      expect(subject.errors).to eql name: ["is already taken"]
    end
  end
end
