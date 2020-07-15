require "rails_helper"

RSpec.describe Plan, type: :model do
  subject { build :plan }

  it "can be saved" do
    expect(subject).to be_valid
    subject.save
  end

  context "validations" do
    it "requires name" do
      subject.name = nil
      expect(subject).not_to be_valid
      expect(subject.errors).to eql name: ["is not present"]
    end

    it "doesn't allow to enable health passport without testing" do
      subject.testing_enabled = false
      expect(subject).not_to be_valid
      expect(subject.errors).to eql health_passport_enabled: ["requires testing to be enabled"]
      subject.health_passport_enabled = false
      expect(subject).to be_valid
    end

    it "checks that employer_limit is an integer" do
      subject.employer_limit = "A"
      expect(subject).not_to be_valid
      expect(subject.errors).to eql employer_limit: ["is not a number"]
    end

    it "checks that employee_limit is an integer" do
      subject.employee_limit = "A"
      expect(subject).not_to be_valid
      expect(subject.errors).to eql employee_limit: ["is not a number"]
    end

    it "checks that remote_id is a number" do
      subject.remote_id = "A"
      expect(subject).not_to be_valid
      expect(subject.errors).to eql remote_id: ["is not a number"]
    end
  end
end
