require "rails_helper"

RSpec.describe Employee, type: :model do
  subject { build :employee }

  it "can be saved" do
    expect(subject).to be_valid
    subject.save
  end

  context "validations" do
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

    it "checks that email is unique within the company" do
      create :employee, email: subject.email
      expect(subject).to be_valid
      create :employee, company: subject.company, email: subject.email
      expect(subject).not_to be_valid
      expect(subject.errors).to eql email: ["is already taken"]
    end

    it "requires phone" do
      subject.phone = nil
      expect(subject).not_to be_valid
      expect(subject.errors).to eql phone: ["is not present"]
    end

    it "requires state or zipcode" do
      subject.state = nil
      expect(subject).not_to be_valid
      expect(subject.errors).to eql state: ["is not present"]
      zip_code = create :zip_code
      subject.zipcode = zip_code.zip
      expect(subject).to be_valid
      expect(subject.state).to eql zip_code.state
    end

    it "checks that state is a valid US state code" do
      subject.state = "ZZ"
      expect(subject).not_to be_valid
      expect(subject.errors).to eql state: ["must be a valid state code"]
    end

    it "checks that zip_code exists" do
      subject.zipcode = Faker::Address.unique.zip_code
      expect(subject).not_to be_valid
      expect(subject.errors).to eql zipcode: ["must be a valid ZIP Code"]
    end
  end
end
