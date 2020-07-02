require "rails_helper"

RSpec.describe ::EmployerPortal::Email::Composer do
  let :with_merge_keys do
    <<-eos.squish
      daily_checkup_status: "{{daily_checkup_status}}"
      employee_email: "{{employee_email}}"
      employee_full_name: "{{employee_full_name}}"
      employee_reset_password_token: "{{employee_reset_password_token}}"
      employer_email: "{{employer_email}}"
      employer_first_name: "{{employer_first_name}}"
      employer_last_name: "{{employer_last_name}}"
      employer_reset_password_token: "{{employer_reset_password_token}}"
      employer_password: "{{employer_password}}"
    eos
  end
  let(:email_template) { create :email_template, subject: with_merge_keys, html: with_merge_keys, text: with_merge_keys }
  let(:employer) { create :employer }
  let(:employee) { create :employee, company: employer.company, employer: employer }
  let(:opts) { {} }
  subject { described_class.new email_template, recipient, opts }

  context "when recipient is employee" do
    let(:recipient) { employee }

    context "without special opts" do
      let :expected do
        <<-eos.squish
          daily_checkup_status: ""
          employee_email: "#{employee.email}"
          employee_full_name: "#{employee.first_name} #{employee.last_name}"
          employee_reset_password_token: ""
          employer_email: "#{employer.email}"
          employer_first_name: "#{employer.first_name}"
          employer_last_name: "#{employer.last_name}"
          employer_reset_password_token: ""
          employer_password: ""
        eos
      end

      it "replaces merge tags" do
        expect(subject.subject).to eql expected
        expect(subject.html).to eql expected
        expect(subject.text).to eql expected
      end
    end

    context "with password reset token" do
      let(:opts) { { "reset_password_token" => "12345" } }

      it "replaces merge tags" do
        expect(subject.subject).to include('employee_reset_password_token: "12345"')
        expect(subject.html).to include('employee_reset_password_token: "12345"')
        expect(subject.text).to include('employee_reset_password_token: "12345"')
      end
    end

    context "with daily_checkup_status" do
      let(:dashboard_employee) { double :dashboard_employee, full_name: "Another Fullname", daily_checkup_status: "Cleared" }

      it "replaces merge tags" do
        allow(::EmployerPortal::Sync).to receive(:connected?).and_return true
        without_partial_double_verification do
          allow(employee).to receive(:dashboard_employee).and_return dashboard_employee
        end
        expect(subject.subject).to include('daily_checkup_status: "Cleared"')
        expect(subject.html).to include('daily_checkup_status: "Cleared"')
        expect(subject.text).to include('daily_checkup_status: "Cleared"')
        expect(subject.subject).to include('employee_full_name: "Another Fullname"')
        expect(subject.html).to include('employee_full_name: "Another Fullname"')
        expect(subject.text).to include('employee_full_name: "Another Fullname"')
      end
    end
  end

  context "when recipient is employer" do
    let(:recipient) { employer }

    context "without special opts" do
      let :expected do
        <<-eos.squish
          daily_checkup_status: ""
          employee_email: ""
          employee_full_name: ""
          employee_reset_password_token: ""
          employer_email: "#{employer.email}"
          employer_first_name: "#{employer.first_name}"
          employer_last_name: "#{employer.last_name}"
          employer_reset_password_token: ""
          employer_password: ""
        eos
      end

      it "replaces merge tags" do
        expect(subject.subject).to eql expected
        expect(subject.html).to eql expected
        expect(subject.text).to eql expected
      end
    end

    context "with password reset token" do
      let(:opts) { { "reset_password_token" => "12345" } }

      it "replaces merge tags" do
        expect(subject.subject).to include('employer_reset_password_token: "12345"')
        expect(subject.html).to include('employer_reset_password_token: "12345"')
        expect(subject.text).to include('employer_reset_password_token: "12345"')
      end
    end

    context "with password" do
      let(:opts) { { "password" => "12345" } }

      it "replaces merge tags" do
        expect(subject.subject).to include('employer_password: "12345"')
        expect(subject.html).to include('employer_password: "12345"')
        expect(subject.text).to include('employer_password: "12345"')
      end
    end
  end
end
