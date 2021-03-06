# frozen_string_literal: true

require "rails_helper"

RSpec.describe "employees", type: :request do
  describe "on collection" do
    describe "index" do
      it { is_expected.to require_authentication :get, employees_path }

      context "when authenticated" do
        before { sign_in_as_employer }

        it { is_expected.to render_successfully :get, employees_path }
      end
    end

    describe "new" do
      it { is_expected.to require_authentication :get, new_employee_path }

      context "when authenticated" do
        before { sign_in_as_employer }

        it { is_expected.to render_successfully :get, new_employee_path }
      end
    end

    describe "create" do
      it { is_expected.to require_authentication :post, employees_path }

      context "when authenticated" do
        before { sign_in_as_employer }

        it { is_expected.to render_successfully :post, employees_path }
      end
    end

    describe "bulk_import" do
      it { is_expected.to require_authentication :get, bulk_import_employees_path }

      context "when authenticated" do
        before { sign_in_as_employer }

        it { is_expected.to render_successfully :get, bulk_import_employees_path }
      end
    end

    describe "delete_all" do
      it { is_expected.to require_authentication :delete, delete_all_employees_path }

      context "when authenticated" do
        let(:company) { create :company }
        let(:employer) { create :employer, company: company }
        let!(:employee) { create :employee, company: company, employer: employer }
        let!(:from_another_employer) { create :employee, company: company }
        let!(:from_another_company) { create :employee }
        before { sign_in_as_employer employer }

        context "when environment is development" do
          before { allow(Rails.env).to receive(:development?).and_return true }

          it "deletes all company employees and redirect to index" do
            expect do
              delete delete_all_employees_path
            end.to change { Employee.count }.by(-1)
            expect { employee.reload }.to raise_error Sequel::NoExistingObject
            expect(response).to redirect_to employees_path
          end
        end

        context "otherwise" do
          it "returns status 404" do
            delete delete_all_employees_path
            expect(response).to have_http_status(:not_found)
          end
        end
      end
    end
  end

  describe "on member" do
    let(:company) { create :company }
    let(:employer) { create :employer, company: company }

    describe "show" do
      context "with an employee of my company" do
        let(:employee) { create :employee, company: company }

        it { is_expected.to require_authentication :get, employee_path(employee) }

        it "redirects to edit without message" do
          sign_in_as_employer employer
          get employee_path(employee)
          expect(response).to redirect_to edit_employee_path(employee)
          expect(flash).to be_empty
        end
      end

      context "with an employee of another company" do
        let(:employee) { create :employee }

        it { is_expected.to require_authentication :get, employee_path(employee) }

        it "redirects to edit without message" do
          sign_in_as_employer employer
          get employee_path(employee)
          expect(response).to redirect_to edit_employee_path(employee)
          expect(flash).to be_empty
        end
      end
    end

    describe "edit" do
      context "with an employee of my company" do
        let(:employee) { create :employee, company: company }

        it { is_expected.to require_authentication :get, edit_employee_path(employee) }

        it "renders successfully" do
          sign_in_as_employer employer
          is_expected.to render_successfully :get, edit_employee_path(employee)
        end
      end

      context "with an employee of another company" do
        let(:employee) { create :employee }

        it { is_expected.to require_authentication :get, edit_employee_path(employee) }

        it "redirects to edit with an alert" do
          sign_in_as_employer employer
          get edit_employee_path(employee)
          expect(response).to redirect_to employees_path
          expect(flash[:alert]).to eql "Employee not found."
        end
      end
    end

    describe "update" do
      context "with an employee of my company" do
        let(:employee) { create :employee, company: company }

        it { is_expected.to require_authentication :patch, employee_path(employee) }

        it "redirects to index with a notice" do
          sign_in_as_employer employer
          expect do
            patch employee_path(employee), params: { employee: { first_name: "Bob" } }
          end.to change { employee.reload.first_name }.to("Bob")
          expect(response).to redirect_to employees_path
          expect(flash[:notice]).to eql "Employee was updated successfully."
        end
      end

      context "with an employee of another company" do
        let(:employee) { create :employee }

        it { is_expected.to require_authentication :patch, employee_path(employee) }

        it "redirects to index with an alert" do
          sign_in_as_employer employer
          expect do
            patch employee_path(employee), params: { employee: { first_name: "Bob" } }
          end.not_to change { employee.reload.first_name }
          expect(response).to redirect_to employees_path
          expect(flash[:alert]).to eql "Employee not found."
        end
      end
    end

    describe "destroy" do
      context "with an employee of my company" do
        let!(:employee) { create :employee, company: company }

        it { is_expected.to require_authentication :delete, employee_path(employee) }

        context "when sync is connected", type: :sync do
          before { with_sync_connected }

          context "but employee has no account yet" do
            it "redirects to edit with an alert" do
              sign_in_as_employer employer
              delete employee_path(employee)
              expect(response).to redirect_to edit_employee_path(employee)
              expect(flash[:alert]).to eql "Employee has no account yet."
            end
          end

          context "and employee has an account" do
            before do
              ::EmployerPortal::Sync.create_partner_for_company! company
              ::EmployerPortal::Sync.create_account_for_employee! employee
            end

            context "when account is active" do
              it "deactivates the employee and redirects to edit with a notice" do
                sign_in_as_employer employer
                expect do
                  delete employee_path(employee)
                end.to change { ::EmployerPortal::Sync::Account[employee.remote_id].is_active }.from(1).to(0)
                expect(response).to redirect_to edit_employee_path(employee)
                expect(flash[:notice]).to eql "Employee was deactivated successfully."
              end
            end

            context "when account is inactive" do
              before { ::EmployerPortal::Sync::Account[employee.remote_id].update is_active: false }

              it "doesn't change account and redirects to edit with an alert" do
                sign_in_as_employer employer
                expect do
                  delete employee_path(employee)
                end.not_to change { ::EmployerPortal::Sync::Account[employee.remote_id].is_active }
                expect(response).to redirect_to edit_employee_path(employee)
                expect(flash[:alert]).to eql "Employee was already inactive."
              end
            end
          end
        end

        context "when sync is NOT connected" do
          it "redirects to edit with an alert" do
            sign_in_as_employer employer
            delete employee_path(employee)
            expect(response).to redirect_to edit_employee_path(employee)
            expect(flash[:alert]).to eql "Temporarily unavailable, please come back later."
          end
        end
      end

      context "with an employee of another company" do
        let!(:employee) { create :employee }

        it { is_expected.to require_authentication :delete, employee_path(employee) }

        context "when sync is connected", type: :sync do
          before { with_sync_connected }

          context "but employee has no account yet" do
            it "redirects to index with an alert" do
              sign_in_as_employer employer
              delete employee_path(employee)
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
                delete employee_path(employee)
              end.not_to change { ::EmployerPortal::Sync::Account[employee.remote_id].is_active }
              expect(response).to redirect_to employees_path
              expect(flash[:alert]).to eql "Employee not found."
            end
          end
        end

        context "when sync is NOT connected" do
          it "redirects to edit with an alert" do
            sign_in_as_employer employer
            delete employee_path(employee)
            expect(response).to redirect_to edit_employee_path(employee)
            expect(flash[:alert]).to eql "Temporarily unavailable, please come back later."
          end
        end
      end
    end

    describe "reactivate" do
      context "with an employee of my company" do
        let!(:employee) { create :employee, company: company }

        it { is_expected.to require_authentication :patch, reactivate_employee_path(employee) }

        context "when sync is connected", type: :sync do
          before { with_sync_connected }

          context "but employee has no account yet" do
            it "redirects to edit with an alert" do
              sign_in_as_employer employer
              patch reactivate_employee_path(employee)
              expect(response).to redirect_to edit_employee_path(employee)
              expect(flash[:alert]).to eql "Employee has no account yet."
            end
          end

          context "and employee has an account" do
            before do
              ::EmployerPortal::Sync.create_partner_for_company! company
              ::EmployerPortal::Sync.create_account_for_employee! employee
            end

            context "when account is active" do
              it "doesn't change account and redirects to edit with an alert" do
                sign_in_as_employer employer
                expect do
                  patch reactivate_employee_path(employee)
                end.not_to change { ::EmployerPortal::Sync::Account[employee.remote_id].is_active }
                expect(response).to redirect_to edit_employee_path(employee)
                expect(flash[:alert]).to eql "Employee was already active."
              end
            end

            context "when account is inactive" do
              before { ::EmployerPortal::Sync::Account[employee.remote_id].update is_active: false }

              it "reactivates the employee and redirects to edit with a notice" do
                sign_in_as_employer employer
                expect do
                  patch reactivate_employee_path(employee)
                end.to change { ::EmployerPortal::Sync::Account[employee.remote_id].is_active }.from(0).to(1)
                expect(response).to redirect_to edit_employee_path(employee)
                expect(flash[:notice]).to eql "Employee was reactivated successfully."
              end
            end
          end
        end

        context "when sync is NOT connected" do
          it "redirects to edit with an alert" do
            sign_in_as_employer employer
            patch reactivate_employee_path(employee)
            expect(response).to redirect_to edit_employee_path(employee)
            expect(flash[:alert]).to eql "Temporarily unavailable, please come back later."
          end
        end
      end

      context "with an employee of another company" do
        let!(:employee) { create :employee }

        it { is_expected.to require_authentication :patch, reactivate_employee_path(employee) }

        context "when sync is connected", type: :sync do
          before { with_sync_connected }

          context "but employee has no account yet" do
            it "redirects to index with an alert" do
              sign_in_as_employer employer
              patch reactivate_employee_path(employee)
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
                patch reactivate_employee_path(employee)
              end.not_to change { ::EmployerPortal::Sync::Account[employee.remote_id].is_active }
              expect(response).to redirect_to employees_path
              expect(flash[:alert]).to eql "Employee not found."
            end
          end
        end

        context "when sync is NOT connected" do
          it "redirects to edit with an alert" do
            sign_in_as_employer employer
            patch reactivate_employee_path(employee)
            expect(response).to redirect_to edit_employee_path(employee)
            expect(flash[:alert]).to eql "Temporarily unavailable, please come back later."
          end
        end
      end
    end

    describe "contact" do
      context "with an employee of my company" do
        let!(:employee) { create :employee, company: company }

        it { is_expected.to require_authentication :patch, contact_employee_path(employee) }

        context "when sync is connected", type: :sync do
          before { with_sync_connected }

          context "and company has daily checkup enabled" do
            it "triggers email and redirects to edit with a notice" do
              sign_in_as_employer employer
              expect do
                patch contact_employee_path(employee)
              end.to have_enqueued_job(EmailTriggerJob).with(
                EmailTemplate::TRIGGER_EMPLOYEE_CONTACT,
                employee.uuid,
              )
              expect(response).to redirect_to edit_employee_path(employee)
              expect(flash[:notice]).to eql "Employee was contacted successfully."
            end
          end

          context "but company has daily checkup disabled" do
            before { company.plan.update daily_checkup_enabled: false }

            it "triggers no email and redirects to edit with an alert" do
              sign_in_as_employer employer
              expect do
                patch contact_employee_path(employee)
              end.not_to have_enqueued_job(EmailTriggerJob)
              expect(response).to redirect_to edit_employee_path(employee)
              expect(flash[:alert]).to eql "Feature not included in your current plan."
            end
          end
        end

        context "when sync is NOT connected" do
          it "redirects to edit with an alert" do
            sign_in_as_employer employer
            patch contact_employee_path(employee)
            expect(response).to redirect_to edit_employee_path(employee)
            expect(flash[:alert]).to eql "Temporarily unavailable, please come back later."
          end
        end
      end

      context "with an employee of another company" do
        let!(:employee) { create :employee }

        it { is_expected.to require_authentication :patch, contact_employee_path(employee) }

        context "when sync is connected", type: :sync do
          before { with_sync_connected }

          context "and company has daily checkup enabled" do
            it "triggers no email and redirects to index with an alert" do
              sign_in_as_employer employer
              expect do
                patch contact_employee_path(employee)
              end.not_to have_enqueued_job(EmailTriggerJob)
              expect(response).to redirect_to employees_path
              expect(flash[:alert]).to eql "Employee not found."
            end
          end

          context "but company has daily checkup disabled" do
            before { company.plan.update daily_checkup_enabled: false }

            it "triggers no email and redirects to edit with an alert" do
              sign_in_as_employer employer
              expect do
                patch contact_employee_path(employee)
              end.not_to have_enqueued_job(EmailTriggerJob)
              expect(response).to redirect_to edit_employee_path(employee)
              expect(flash[:alert]).to eql "Feature not included in your current plan."
            end
          end
        end

        context "when sync is NOT connected" do
          it "redirects to edit with an alert" do
            sign_in_as_employer employer
            patch contact_employee_path(employee)
            expect(response).to redirect_to edit_employee_path(employee)
            expect(flash[:alert]).to eql "Temporarily unavailable, please come back later."
          end
        end
      end
    end

    describe "send_reminder" do
      context "with an employee of my company" do
        let!(:employee) { create :employee, company: company }

        it { is_expected.to require_authentication :patch, send_reminder_employee_path(employee) }

        context "when sync is connected", type: :sync do
          before { with_sync_connected }

          context "and company has daily checkup enabled" do
            it "triggers email and redirects to edit with a notice" do
              sign_in_as_employer employer
              expect do
                patch send_reminder_employee_path(employee)
              end.to have_enqueued_job(EmailTriggerJob).with(
                EmailTemplate::TRIGGER_EMPLOYEE_REMINDER,
                employee.uuid,
              )
              expect(response).to redirect_to edit_employee_path(employee)
              expect(flash[:notice]).to eql "Employee reminder was sent successfully."
            end
          end

          context "but company has daily checkup disabled" do
            before { company.plan.update daily_checkup_enabled: false }

            it "triggers no email and redirects to edit with an alert" do
              sign_in_as_employer employer
              expect do
                patch send_reminder_employee_path(employee)
              end.not_to have_enqueued_job(EmailTriggerJob)
              expect(response).to redirect_to edit_employee_path(employee)
              expect(flash[:alert]).to eql "Feature not included in your current plan."
            end
          end
        end

        context "when sync is NOT connected" do
          it "redirects to edit with an alert" do
            sign_in_as_employer employer
            patch send_reminder_employee_path(employee)
            expect(response).to redirect_to edit_employee_path(employee)
            expect(flash[:alert]).to eql "Temporarily unavailable, please come back later."
          end
        end
      end

      context "with an employee of another company" do
        let!(:employee) { create :employee }

        it { is_expected.to require_authentication :patch, send_reminder_employee_path(employee) }

        context "when sync is connected", type: :sync do
          before { with_sync_connected }

          context "and company has daily checkup enabled" do
            it "triggers no email and redirects to index with an alert" do
              sign_in_as_employer employer
              expect do
                patch send_reminder_employee_path(employee)
              end.not_to have_enqueued_job(EmailTriggerJob)
              expect(response).to redirect_to employees_path
              expect(flash[:alert]).to eql "Employee not found."
            end
          end

          context "but company has daily checkup disabled" do
            before { company.plan.update daily_checkup_enabled: false }

            it "triggers no email and redirects to edit with an alert" do
              sign_in_as_employer employer
              expect do
                patch send_reminder_employee_path(employee)
              end.not_to have_enqueued_job(EmailTriggerJob)
              expect(response).to redirect_to edit_employee_path(employee)
              expect(flash[:alert]).to eql "Feature not included in your current plan."
            end
          end
        end

        context "when sync is NOT connected" do
          it "redirects to edit with an alert" do
            sign_in_as_employer employer
            patch send_reminder_employee_path(employee)
            expect(response).to redirect_to edit_employee_path(employee)
            expect(flash[:alert]).to eql "Temporarily unavailable, please come back later."
          end
        end
      end
    end

    describe "health_passport" do
      context "with an employee of my company" do
        let!(:employee) { create :employee, company: company }

        it { is_expected.to require_authentication :get, health_passport_employee_path(employee) }

        context "when sync is connected", type: :sync do
          before { with_sync_connected }

          context "but employee has no account yet" do
            it "renders successfully" do
              sign_in_as_employer employer
              get health_passport_employee_path(employee)
              expect(response).to have_http_status :success
              expect(flash).to be_empty
              expect(response.body).to include("Health Passport is still in progress")
            end
          end

          context "and employee has an account" do
            before do
              ::EmployerPortal::Sync.create_partner_for_company! company
              ::EmployerPortal::Sync.create_account_for_employee! employee
            end

            it "renders successfully" do
              sign_in_as_employer employer
              get health_passport_employee_path(employee)
              expect(response).to have_http_status :success
              expect(flash).to be_empty
              expect(response.body).to include("Health Passport is still in progress")
            end
          end
        end

        context "when sync is NOT connected" do
          it "redirects to edit with an alert" do
            sign_in_as_employer employer
            get health_passport_employee_path(employee)
            expect(response).to redirect_to edit_employee_path(employee)
            expect(flash[:alert]).to eql "Temporarily unavailable, please come back later."
          end
        end
      end

      context "with an employee of another company" do
        let!(:employee) { create :employee }

        it { is_expected.to require_authentication :get, health_passport_employee_path(employee) }

        context "when sync is connected", type: :sync do
          before { with_sync_connected }

          context "but employee has no account yet" do
            it "redirects to index with an alert" do
              sign_in_as_employer employer
              get health_passport_employee_path(employee)
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
                get health_passport_employee_path(employee)
              end.not_to change { ::EmployerPortal::Sync::Account[employee.remote_id].is_active }
              expect(response).to redirect_to employees_path
              expect(flash[:alert]).to eql "Employee not found."
            end
          end
        end

        context "when sync is NOT connected" do
          it "redirects to edit with an alert" do
            sign_in_as_employer employer
            get health_passport_employee_path(employee)
            expect(response).to redirect_to edit_employee_path(employee)
            expect(flash[:alert]).to eql "Temporarily unavailable, please come back later."
          end
        end
      end
    end
  end
end
