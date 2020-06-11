require "rails_helper"

RSpec.describe Employer, type: :model do
  subject { build :employer }

  it "can be saved" do
    expect(subject).to be_valid
    subject.save
  end

  context "validations" do
    it "requires email" do
      subject.email = nil
      expect(subject).not_to be_valid
      expect(subject.errors).to eql email: ["is not present"]
    end

    it "checks email format" do
      subject.email = "@"
      expect(subject).not_to be_valid
      expect(subject.errors).to eql email: ["is invalid"]
    end

    it "checks that email is unique within the company" do
      create(:employer, email: subject.email)
      expect(subject).to be_valid
      create(:employer, company_id: subject.company_id, email: subject.email)
      expect(subject).not_to be_valid
      expect(subject.errors).to eql email: ["is already taken"]
    end

    it "requires role" do
      subject.role = nil
      expect(subject).not_to be_valid
      expect(subject.errors).to eql role: ["is not present"]
    end
  end
end
