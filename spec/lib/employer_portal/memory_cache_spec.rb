require "rails_helper"

RSpec.describe ::EmployerPortal::MemoryCache do
  include ActiveSupport::Testing::TimeHelpers

  it "default max_size is 50" do
    expect(subject.max_size).to eql(50)
  end

  it "implements the Ruby-Memcache API" do
    subject.set("key1", 1, 30)
    expect(subject.get("key1")).to be 1
    expect(subject.get("key2")).to be_nil
    subject.delete("key1")
    expect(subject.get("key1")).to be_nil
  end

  it "ignores the given time-to-live in seconds" do
    travel -1.day do
      subject.set("key1", 1, 1)
    end
    expect(subject.get("key1")).to be 1
  end

  context "when max_size is 2" do
    subject { described_class.new(2) }

    it "can't store more than 2 items" do
      subject.set("key1", 1)
      subject.set("key2", 2)
      subject.set("key3", 3)
      expect(subject.get("key1")).to be_nil
      expect(subject.get("key2")).to be 2
      expect(subject.get("key3")).to be 3
    end

    it "removes the least used key" do
      subject.set("key1", 1)
      subject.set("key2", 2)
      subject.set("key3", 3)
      subject.set("key2", 2)
      subject.set("key4", 4)
      expect(subject.get("key1")).to be_nil
      expect(subject.get("key3")).to be_nil
      expect(subject.get("key2")).to be 2
      expect(subject.get("key4")).to be 4
    end

    it "allows to delete one key" do
      subject.set("key1", 1)
      subject.delete("key1")
      expect(subject.get("key1")).to be_nil
    end
  end
end
