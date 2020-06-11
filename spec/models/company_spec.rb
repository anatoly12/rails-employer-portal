require "rails_helper"

RSpec.describe Company, type: :model do
  subject { build :company }

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

    it "requires plan" do
      subject.plan = nil
      expect(subject).not_to be_valid
      expect(subject.errors).to eql plan: ["is not present"]
    end
  end
end
