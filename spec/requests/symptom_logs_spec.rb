# frozen_string_literal: true

require "rails_helper"

RSpec.describe "symptom_logs", type: :request do
  let(:company) { create :company }
  let(:employer) { create :employer, company: company }
  let(:date) { Date.new 2020, 6, 10 }

  context "with an employee of my company" do
    let!(:employee) { create :employee, company: company }

    it { is_expected.to require_authentication :get, employee_symptom_log_path(employee, date.to_s) }

    context "when sync is connected", type: :sync do
      before { with_sync_connected }

      context "but employee has no account yet" do
        it "redirects to edit with an alert" do
          sign_in_as_employer employer
          get employee_symptom_log_path(employee, date.to_s)
          expect(response).to redirect_to edit_employee_path(employee)
          expect(flash[:alert]).to eql "Employee has no account yet."
        end
      end

      context "and employee has an account" do
        before do
          ::EmployerPortal::Sync.create_partner_for_company! company
          ::EmployerPortal::Sync.create_account_for_employee! employee
        end

        context "when company has daily checkup enabled" do
          it "renders successfully" do
            sign_in_as_employer employer
            is_expected.to render_successfully :get, employee_symptom_log_path(employee, date.to_s)
          end
        end

        context "when company has daily checkup disabled" do
          before { company.plan.update daily_checkup_enabled: false }

          it "redirects to edit with an alert" do
            sign_in_as_employer employer
            get employee_symptom_log_path(employee, date.to_s)
            expect(response).to redirect_to edit_employee_path(employee)
            expect(flash[:alert]).to eql "Feature not included in your current plan."
          end
        end
      end
    end

    context "when sync is NOT connected" do
      it "redirects to edit with an alert" do
        sign_in_as_employer employer
        get employee_symptom_log_path(employee, date.to_s)
        expect(response).to redirect_to edit_employee_path(employee)
        expect(flash[:alert]).to eql "Temporarily unavailable, please come back later."
      end
    end
  end

  context "with an employee of another company" do
    let!(:employee) { create :employee }

    it { is_expected.to require_authentication :get, employee_symptom_log_path(employee, date.to_s) }

    context "when sync is connected", type: :sync do
      before { with_sync_connected }

      context "but employee has no account yet" do
        it "redirects to index with an alert" do
          sign_in_as_employer employer
          get employee_symptom_log_path(employee, date.to_s)
          expect(response).to redirect_to employees_path
          expect(flash[:alert]).to eql "Employee not found."
        end
      end

      context "and employee has an account" do
        before do
          ::EmployerPortal::Sync.create_partner_for_company! company
          ::EmployerPortal::Sync.create_account_for_employee! employee
        end

        it "redirects to index with an alert" do
          sign_in_as_employer employer
          expect do
            get employee_symptom_log_path(employee, date.to_s)
          end.not_to change { ::EmployerPortal::Sync::Account[employee.remote_id].is_active }
          expect(response).to redirect_to employees_path
          expect(flash[:alert]).to eql "Employee not found."
        end
      end
    end

    context "when sync is NOT connected" do
      it "redirects to edit with an alert" do
        sign_in_as_employer employer
        get employee_symptom_log_path(employee, date.to_s)
        expect(response).to redirect_to edit_employee_path(employee)
        expect(flash[:alert]).to eql "Temporarily unavailable, please come back later."
      end
    end
  end
end
