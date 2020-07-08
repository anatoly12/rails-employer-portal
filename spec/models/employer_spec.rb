require "rails_helper"

RSpec.describe Employer, type: :model do
  subject { build :employer }

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

    it "requires role" do
      subject.role = nil
      expect(subject).not_to be_valid
      expect(subject.errors).to eql role: ["is not present"]
    end

    it "requires first name" do
      subject.first_name = nil
      expect(subject).not_to be_valid
      expect(subject.errors).to eql first_name: ["is not present"]
    end

    it "requires last name" do
      subject.last_name = nil
      expect(subject).not_to be_valid
      expect(subject.errors).to eql last_name: ["is not present"]
    end

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

    it "checks that email is unique" do
      create(:employer, email: subject.email)
      expect(subject).not_to be_valid
      expect(subject.errors).to eql email: ["is already taken"]
    end

    it "requires password" do
      subject.password = nil
      expect(subject).not_to be_valid
      expect(subject.errors).to eql password: ["is not present"]
    end
  end
end
