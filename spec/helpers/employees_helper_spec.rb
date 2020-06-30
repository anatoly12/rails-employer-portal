require "rails_helper"

describe EmployeesHelper do
  describe "#temperature_color" do
    subject { helper.temperature_color symptom_log }
    [
      nil, "", "invalid", "100", "100F", "100ºF", "100.3", "100.3F", "100.3ºF", "100.39ºF", "37.9C", "37.9ºC"
    ].each do |temperature|
      context "when temperature is #{temperature}" do
        let(:symptom_log) { double :symptom_log, temperature: temperature }

        it { is_expected.to be_nil }
      end
    end
    [
      "101", "101F", "101ºF", "100.4", "100.4F", "100.4ºF", "38C", "38.0ºC"
    ].each do |temperature|
      context "when temperature is #{temperature}" do
        let(:symptom_log) { double :symptom_log, temperature: temperature }

        it { is_expected.to eql "text-red-600" }
      end
    end
  end
end
