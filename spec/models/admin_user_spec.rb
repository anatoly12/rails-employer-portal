require "rails_helper"

RSpec.describe AdminUser, type: :model do
  subject { build :admin_user }

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

    it "checks that email is unique" do
      create(:admin_user, email: subject.email)
      expect(subject).not_to be_valid
      expect(subject.errors).to eql email: ["is already taken"]
    end

    context "when the admin user is new" do
      it "requires password" do
        subject.password = nil
        expect(subject).not_to be_valid
        expect(subject.errors).to eql password: ["is not present"]
      end

      it "checks that password isn't too short" do
        subject.password = "1" * 5
        expect(subject).not_to be_valid
        expect(subject.errors).to eql password: ["is too short (min is 6 characters)"]
      end

      it "checks that password isn't too long" do
        subject.password = "1" * 129
        expect(subject).not_to be_valid
        expect(subject.errors).to eql password: ["is too long (max is 128 characters)"]
      end
    end

    context "when the admin user is already persisted" do
      subject { create :admin_user }

      it "doesn't require password anymore" do
        subject.password = nil
        expect(subject).to be_valid
      end

      it "checks that password isn't too short" do
        subject.password = "1" * 5
        expect(subject).not_to be_valid
        expect(subject.errors).to eql password: ["is too short (min is 6 characters)"]
      end

      it "checks that password isn't too long" do
        subject.password = "1" * 129
        expect(subject).not_to be_valid
        expect(subject.errors).to eql password: ["is too long (max is 128 characters)"]
      end
    end
  end
end
