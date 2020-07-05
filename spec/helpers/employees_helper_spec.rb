require "rails_helper"

describe EmployeesHelper do
  describe "#daily_checkup_color" do
    let(:employee) { double :employee, daily_checkup_status: daily_checkup_status }
    subject { helper.daily_checkup_color employee }

    context "when daily_checkup_status is Cleared" do
      let(:daily_checkup_status) { "Cleared" }

      it { is_expected.to eql "text-green-500" }
    end

    context "when daily_checkup_status is Not Cleared" do
      let(:daily_checkup_status) { "Not Cleared" }

      it { is_expected.to eql "text-red-600" }
    end

    context "when daily_checkup_status is Did Not Submit" do
      let(:daily_checkup_status) { "Did Not Submit" }

      it { is_expected.to eql "text-blue-600" }
    end

    context "when daily_checkup_status is nil" do
      let(:daily_checkup_status) { nil }

      it { is_expected.to eql "text-blue-600" }
    end
  end

  describe "#testing_color" do
    let(:employee) { double :employee, testing_status: testing_status }
    subject { helper.testing_color employee }

    context "when testing_status is Cleared" do
      let(:testing_status) { "Cleared" }

      it { is_expected.to eql "text-green-500" }
    end

    context "when testing_status is Inconclusive" do
      let(:testing_status) { "Inconclusive" }

      it { is_expected.to eql "text-red-600" }
    end

    ["Submitted Results", "Intake", "Registered", "Not Registered"].each do |status|
      context "when testing_status is #{status}" do
        let(:testing_status) { status }

        it { is_expected.to eql "text-blue-600" }
      end
    end

    context "when testing_status is nil" do
      let(:testing_status) { nil }

      it { is_expected.to eql "text-blue-600" }
    end
  end

  describe "#temperature_color" do
    subject { helper.temperature_color symptom_log }
    [
      nil, "", "invalid", "100", "100F", "100ºF", "100.3", "100.3F", "100.3ºF", "100.39ºF", "37.9C", "37.9ºC",
    ].each do |temperature|
      context "when temperature is #{temperature}" do
        let(:symptom_log) { double :symptom_log, temperature: temperature }

        it { is_expected.to be_nil }
      end
    end
    [
      "101", "101F", "101ºF", "100.4", "100.4F", "100.4ºF", "38C", "38.0ºC",
    ].each do |temperature|
      context "when temperature is #{temperature}" do
        let(:symptom_log) { double :symptom_log, temperature: temperature }

        it { is_expected.to eql "text-red-600" }
      end
    end
  end

  describe "#testing_status_color" do
    let(:employer) { create :employer }
    let(:employee) { create :employee, employer: employer }
    let(:context) { ::EmployerPortal::Context.new(account_id: employer.id, section: :application) }
    let(:health_passport) { ::EmployerPortal::HealthPassport.new(context, employee, dashboard_employee) }
    subject { helper.testing_status_color(health_passport) }

    {
      "Cleared" => "text-green-500 border-green-500",
      "Inconclusive" => "text-red-600 border-red-600",
      "Submitted Results" => "text-blue-600 border-blue-600",
      "Intake" => "text-blue-600 border-blue-600",
      "Registered" => "text-blue-600 border-blue-600",
      "Not Registered" => "text-blue-600 border-blue-600",
    }.each do |testing_status, expected|
      context "when testing_status is #{testing_status}" do
        let(:dashboard_employee) { double :dashboard_employee, testing_status: testing_status }

        it { is_expected.to eql expected }
      end
    end
  end

  describe "#health_passport_color" do
    let(:employer) { create :employer }
    let(:employee) { create :employee, employer: employer }
    let(:context) { ::EmployerPortal::Context.new(account_id: employer.id, section: :application) }
    let(:health_passport) { ::EmployerPortal::HealthPassport.new(context, employee, dashboard_employee) }
    subject { helper.health_passport_color(health_passport) }

    {
      "Cleared" => "bg-green-500",
      "Inconclusive" => "bg-red-600",
      "Submitted Results" => "bg-blue-600",
      "Intake" => "bg-blue-600",
      "Registered" => "bg-blue-600",
      "Not Registered" => "bg-blue-600",
    }.each do |testing_status, expected|
      context "when testing_status is #{testing_status}" do
        let(:dashboard_employee) { double :dashboard_employee, testing_status: testing_status }

        it { is_expected.to eql expected }
      end
    end
  end
end
