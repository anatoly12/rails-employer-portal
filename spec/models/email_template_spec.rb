require "rails_helper"

RSpec.describe EmailTemplate, type: :model do
  subject { build :email_template }

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

    it "requires trigger_key" do
      subject.trigger_key = nil
      expect(subject).not_to be_valid
      expect(subject.errors).to eql trigger_key: ["is not present"]
    end

    it "requires from" do
      subject.from = nil
      expect(subject).not_to be_valid
      expect(subject.errors).to eql from: ["is not present"]
    end

    it "requires subject" do
      subject.subject = nil
      expect(subject).not_to be_valid
      expect(subject.errors).to eql subject: ["is not present"]
    end

    it "checks that covid19_message_code is a number" do
      subject.covid19_message_code = "A"
      expect(subject).not_to be_valid
      expect(subject.errors).to eql covid19_message_code: ["is not a number"]
    end
  end
end
