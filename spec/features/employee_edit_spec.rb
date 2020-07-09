require "rails_helper"

feature "Employee edit" do
  include ApplicationHelpers
  include SyncHelpers

  given(:company) { create :company }
  given(:employer) { create :employer, company: company }
  given!(:employee) { create :employee, company: company }
  given!(:from_another_company) { create :employee }
  given(:now) { Time.now }
  given(:today) { now.to_date }
  before { sign_in_as_employer employer }

  context "with sync connected", type: :sync do
    before do
      with_sync_connected
      ::EmployerPortal::Sync.create_partner_for_company! company
    end

    describe "when employee hasn't been synced yet" do
      scenario "I see no action button" do
        visit_employee_edit
        expect(page.find_by_id("symptom-tracker")["class"]).not_to include "bg-gray-100"
        within "#symptom-tracker tbody" do
          expect(page).not_to have_css("tr")
        end
        expect(page.find_by_id("testing-progress")["class"]).not_to include "bg-gray-100"
        within "#testing-progress" do
          expect(page).to have_css(".bg-blue-400", count: 1)
          within "li:nth-child(1)" do
            expect(page).to have_css ".bg-blue-400"
            expect(page).to have_content "Not Registered"
          end
          expect(page).to have_css("a[href$='/employees/#{employee.uuid}/health_passport']", text: "Not Registered")
        end
        expect(page).not_to have_css "#action_buttons"
      end
    end

    describe "when employee daily checkup is Did Not Submit" do
      before { ::EmployerPortal::Sync.create_account_for_employee! employee }

      scenario "I see the Send Reminder link" do
        visit_employee_edit
        expect(page.find_by_id("symptom-tracker")["class"]).not_to include "bg-gray-100"
        within "#symptom-tracker tbody" do
          expect(page).not_to have_css("tr")
        end
        expect(page.find_by_id("testing-progress")["class"]).not_to include "bg-gray-100"
        within "#testing-progress" do
          expect(page).to have_css(".bg-blue-400", count: 1)
          within "li:nth-child(1)" do
            expect(page).to have_css ".bg-blue-400"
            expect(page).to have_content "Not Registered"
          end
          expect(page).to have_css("a[href$='/employees/#{employee.uuid}/health_passport']", text: "Not Registered")
        end
        within "#action_buttons" do
          expect(page).to have_content "Contact not needed"
          expect(page).not_to have_link "Contact"
          expect(page).to have_link "Send Reminder"
          expect(page).to have_link "Deactivate"
        end
      end

      scenario "I can't click on the Send Reminder link twice" do
        visit_employee_edit
        expect {
          click_link "Send Reminder"
        }.to have_enqueued_job(EmailTriggerJob).with(
          EmailTemplate::TRIGGER_EMPLOYEE_REMINDER,
          employee.uuid,
        )
        expect(page).to have_css("[role=notice]", text: "Employee reminder was sent successfully.")
        expect(page).not_to have_css("[role=alert]")
        expect(page.find_by_id("symptom-tracker")["class"]).not_to include "bg-gray-100"
        within "#symptom-tracker tbody" do
          expect(page).not_to have_css("tr")
        end
        expect(page.find_by_id("testing-progress")["class"]).not_to include "bg-gray-100"
        within "#testing-progress" do
          expect(page).to have_css(".bg-blue-400", count: 1)
          within "li:nth-child(1)" do
            expect(page).to have_css ".bg-blue-400"
            expect(page).to have_content "Not Registered"
          end
          expect(page).to have_css("a[href$='/employees/#{employee.uuid}/health_passport']", text: "Not Registered")
        end
        within "#action_buttons" do
          expect(page).to have_content "Contact not needed"
          expect(page).not_to have_link "Contact"
          expect(page).to have_content "Reminder sent on"
          expect(page).not_to have_link "Send Reminder"
          expect(page).to have_link "Deactivate"
        end
      end

      scenario "I can deactivate employee" do
        visit_employee_edit
        expect(page).to have_css "h2", text: "Review, edit or deactivate an employee's account"
        click_link "Deactivate"
        expect(page).to have_css("[role=notice]", text: "Employee was deactivated successfully.")
        expect(page).not_to have_css("[role=alert]")
        expect(page).to have_css "h2", text: "Employee's account is currently deactivated"
        within "#action_buttons" do
          expect(page).to have_css "a", count: 1
          expect(page).to have_link "Reactivate"
          click_link "Reactivate"
        end
        expect(page).to have_css("[role=notice]", text: "Employee was reactivated successfully.")
        expect(page).not_to have_css("[role=alert]")
        expect(page).to have_css "h2", text: "Review, edit or deactivate an employee's account"
        within "#action_buttons" do
          expect(page).to have_content "Contact not needed"
          expect(page).not_to have_link "Contact"
          expect(page).to have_link "Send Reminder"
          expect(page).to have_link "Deactivate"
        end
      end
    end

    describe "when employee daily checkup is Not Cleared" do
      before do
        ::EmployerPortal::Sync.create_account_for_employee! employee
        ::EmployerPortal::Sync::Covid19DailyCheckupStatus.find_or_create(
          daily_checkup_status_code: 2,
        ) do |status|
          status.daily_checkup_status = "Not Cleared"
        end
        ::EmployerPortal::Sync::Covid19DailyCheckup.create(
          account_id: employee.remote_id,
          daily_checkup_status_code: 2,
          checkup_date: today,
        )
      end

      scenario "I see the Contact link" do
        visit_employee_edit
        expect(page.find_by_id("symptom-tracker")["class"]).not_to include "bg-gray-100"
        within "#symptom-tracker tbody" do
          expect(page).not_to have_css("tr")
        end
        expect(page.find_by_id("testing-progress")["class"]).not_to include "bg-gray-100"
        within "#testing-progress" do
          expect(page).to have_css(".bg-blue-400", count: 1)
          within "li:nth-child(1)" do
            expect(page).to have_css ".bg-blue-400"
            expect(page).to have_content "Not Registered"
          end
          expect(page).to have_css("a[href$='/employees/#{employee.uuid}/health_passport']", text: "Not Registered")
        end
        within "#action_buttons" do
          expect(page).to have_link "Contact"
          expect(page).to have_content "Reminder not needed"
          expect(page).not_to have_link "Send Reminder"
          expect(page).to have_link "Deactivate"
        end
      end

      scenario "I can't click on the Contact link twice" do
        visit_employee_edit
        expect {
          click_link "Contact"
        }.to have_enqueued_job(EmailTriggerJob).with(
          EmailTemplate::TRIGGER_EMPLOYEE_CONTACT,
          employee.uuid,
        )
        expect(page).to have_css("[role=notice]", text: "Employee was contacted successfully.")
        expect(page).not_to have_css("[role=alert]")
        expect(page.find_by_id("symptom-tracker")["class"]).not_to include "bg-gray-100"
        within "#symptom-tracker tbody" do
          expect(page).not_to have_css("tr")
        end
        expect(page.find_by_id("testing-progress")["class"]).not_to include "bg-gray-100"
        within "#testing-progress" do
          expect(page).to have_css(".bg-blue-400", count: 1)
          within "li:nth-child(1)" do
            expect(page).to have_css ".bg-blue-400"
            expect(page).to have_content "Not Registered"
          end
          expect(page).to have_css("a[href$='/employees/#{employee.uuid}/health_passport']", text: "Not Registered")
        end
        within "#action_buttons" do
          expect(page).to have_content "Contacted on"
          expect(page).not_to have_link "Contact"
          expect(page).to have_content "Reminder not needed"
          expect(page).not_to have_link "Send Reminder"
          expect(page).to have_link "Deactivate"
        end
      end
    end

    describe "when employee daily checkup is Cleared" do
      before do
        ::EmployerPortal::Sync.create_account_for_employee! employee
        ::EmployerPortal::Sync::Covid19DailyCheckupStatus.find_or_create(
          daily_checkup_status_code: 1,
        ) do |status|
          status.daily_checkup_status = "Cleared"
        end
        ::EmployerPortal::Sync::Covid19DailyCheckup.create(
          account_id: employee.remote_id,
          daily_checkup_status_code: 1,
          checkup_date: today,
        )
      end

      scenario "I see only the Deactivate link" do
        visit_employee_edit
        expect(page.find_by_id("symptom-tracker")["class"]).not_to include "bg-gray-100"
        within "#symptom-tracker tbody" do
          expect(page).not_to have_css("tr")
        end
        expect(page.find_by_id("testing-progress")["class"]).not_to include "bg-gray-100"
        within "#testing-progress" do
          expect(page).to have_css(".bg-blue-400", count: 1)
          within "li:nth-child(1)" do
            expect(page).to have_css ".bg-blue-400"
            expect(page).to have_content "Not Registered"
          end
          expect(page).to have_css("a[href$='/employees/#{employee.uuid}/health_passport']", text: "Not Registered")
        end
        within "#action_buttons" do
          expect(page).to have_content "Contact not needed"
          expect(page).not_to have_link "Contact"
          expect(page).to have_content "Reminder not needed"
          expect(page).not_to have_link "Send Reminder"
          expect(page).to have_link "Deactivate"
        end
      end
    end

    describe "when employee testing is Cleared" do
      before do
        ::EmployerPortal::Sync.create_account_for_employee! employee
        ::EmployerPortal::Sync::Covid19Evaluation.create(
          account_id: employee.remote_id,
          status: 1,
          updated_at: now,
        )
      end

      scenario "I see that Testing Progress status is Cleared" do
        visit_employee_edit
        expect(page.find_by_id("symptom-tracker")["class"]).not_to include "bg-gray-100"
        within "#symptom-tracker tbody" do
          expect(page).not_to have_css("tr")
        end
        expect(page.find_by_id("testing-progress")["class"]).not_to include "bg-gray-100"
        within "#testing-progress" do
          expect(page).to have_css(".bg-blue-400", count: 1)
          within "li:nth-child(7)" do
            expect(page).to have_css ".bg-blue-400"
            expect(page).to have_content "Passport Complete"
          end
          expect(page).to have_css("a[href$='/employees/#{employee.uuid}/health_passport']", text: "Cleared")
        end
        within "#action_buttons" do
          expect(page).to have_content "Contact not needed"
          expect(page).not_to have_link "Contact"
          expect(page).to have_link "Send Reminder"
          expect(page).to have_link "Deactivate"
        end
      end
    end

    describe "when employee testing is Inconclusive" do
      before do
        ::EmployerPortal::Sync.create_account_for_employee! employee
        ::EmployerPortal::Sync::Covid19Evaluation.create(
          account_id: employee.remote_id,
          status: 5,
          updated_at: now,
        )
      end

      scenario "I see that Testing Progress status is Not Cleared" do
        visit_employee_edit
        expect(page.find_by_id("symptom-tracker")["class"]).not_to include "bg-gray-100"
        within "#symptom-tracker tbody" do
          expect(page).not_to have_css("tr")
        end
        expect(page.find_by_id("testing-progress")["class"]).not_to include "bg-gray-100"
        within "#testing-progress" do
          expect(page).to have_css(".bg-blue-400", count: 1)
          within "li:nth-child(7)" do
            expect(page).to have_css ".bg-blue-400"
            expect(page).to have_content "Passport Complete"
          end
          expect(page).to have_css("a[href$='/employees/#{employee.uuid}/health_passport']", text: "Not Cleared")
        end
        within "#action_buttons" do
          expect(page).to have_content "Contact not needed"
          expect(page).not_to have_link "Contact"
          expect(page).to have_link "Send Reminder"
          expect(page).to have_link "Deactivate"
        end
      end
    end
  end

  def visit_employee_edit
    visit "/employees/#{employee.uuid}/edit"
    expect(page).to have_css "h1", text: "Employee Details"
  end
end
