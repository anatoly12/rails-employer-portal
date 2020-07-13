require "rails_helper"

feature "Employee edit" do
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

    context "when employee hasn't been synced yet" do
      scenario "I see no action button" do
        visit_employee_edit
        within "#symptom-tracker:not(.bg-gray-100)" do
          expect(page).not_to have_css("tbody tr")
        end
        within "#testing-progress:not(.bg-gray-100)" do
          expect(page).to have_css(".bg-blue-400", count: 1)
          within "li:nth-child(1)" do
            expect(page).to have_css ".bg-blue-400"
            expect(page).to have_content "Not Registered"
          end
          expect(page).to have_css("a[href$='/employees/#{employee.uuid}/health_passport']", text: "Not Registered")
        end
        expect(page).to have_css("form#edit_employee_#{employee.id}")
        expect(page).not_to have_css "#action_buttons"
      end
    end

    context "when employee daily checkup is Did Not Submit" do
      before { ::EmployerPortal::Sync.create_account_for_employee! employee }

      scenario "I see the Send Reminder link" do
        visit_employee_edit
        within "#symptom-tracker:not(.bg-gray-100)" do
          expect(page).not_to have_css("tbody tr")
        end
        within "#testing-progress:not(.bg-gray-100)" do
          expect(page).to have_css(".bg-blue-400", count: 1)
          within "li:nth-child(1)" do
            expect(page).to have_css ".bg-blue-400"
            expect(page).to have_content "Not Registered"
          end
          expect(page).to have_css("a[href$='/employees/#{employee.uuid}/health_passport']", text: "Not Registered")
        end
        expect(page).to have_css("form#edit_employee_#{employee.id}")
        within "#action_buttons" do
          expect(page).to have_css "a", count: 2
          expect(page).to have_content "Contact not needed"
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
        within "#symptom-tracker:not(.bg-gray-100)" do
          expect(page).not_to have_css("tbody tr")
        end
        within "#testing-progress:not(.bg-gray-100)" do
          expect(page).to have_css(".bg-blue-400", count: 1)
          within "li:nth-child(1)" do
            expect(page).to have_css ".bg-blue-400"
            expect(page).to have_content "Not Registered"
          end
          expect(page).to have_css("a[href$='/employees/#{employee.uuid}/health_passport']", text: "Not Registered")
        end
        expect(page).to have_css("form#edit_employee_#{employee.id}")
        within "#action_buttons" do
          expect(page).to have_css "a", count: 1
          expect(page).to have_content "Contact not needed"
          expect(page).to have_content "Reminder sent on"
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
        expect(page).to have_css("form#edit_employee_#{employee.id}")
        within "#action_buttons" do
          expect(page).to have_css "a", count: 1
          expect(page).not_to have_content "Contact"
          expect(page).not_to have_content "Remind"
          expect(page).to have_link "Reactivate"
        end
        click_link "Reactivate"
        expect(page).to have_css("[role=notice]", text: "Employee was reactivated successfully.")
        expect(page).not_to have_css("[role=alert]")
        expect(page).to have_css "h2", text: "Review, edit or deactivate an employee's account"
        expect(page).to have_css("form#edit_employee_#{employee.id}")
        within "#action_buttons" do
          expect(page).to have_css "a", count: 2
          expect(page).to have_content "Contact not needed"
          expect(page).to have_link "Send Reminder"
          expect(page).to have_link "Deactivate"
        end
      end
    end

    context "when employee daily checkup is Not Cleared" do
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
        within "#symptom-tracker:not(.bg-gray-100)" do
          expect(page).not_to have_css("tbody tr")
        end
        within "#testing-progress:not(.bg-gray-100)" do
          expect(page).to have_css(".bg-blue-400", count: 1)
          within "li:nth-child(1)" do
            expect(page).to have_css ".bg-blue-400"
            expect(page).to have_content "Not Registered"
          end
          expect(page).to have_css("a[href$='/employees/#{employee.uuid}/health_passport']", text: "Not Registered")
        end
        expect(page).to have_css("form#edit_employee_#{employee.id}")
        within "#action_buttons" do
          expect(page).to have_css "a", count: 2
          expect(page).to have_link "Contact"
          expect(page).to have_content "Reminder not needed"
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
        within "#symptom-tracker:not(.bg-gray-100)" do
          expect(page).not_to have_css("tbody tr")
        end
        within "#testing-progress:not(.bg-gray-100)" do
          expect(page).to have_css(".bg-blue-400", count: 1)
          within "li:nth-child(1)" do
            expect(page).to have_css ".bg-blue-400"
            expect(page).to have_content "Not Registered"
          end
          expect(page).to have_css("a[href$='/employees/#{employee.uuid}/health_passport']", text: "Not Registered")
        end
        expect(page).to have_css("form#edit_employee_#{employee.id}")
        within "#action_buttons" do
          expect(page).to have_css "a", count: 1
          expect(page).to have_content "Contacted on"
          expect(page).to have_content "Reminder not needed"
          expect(page).to have_link "Deactivate"
        end
      end
    end

    context "when employee has some symptom logs" do
      include ActiveSupport::Testing::TimeHelpers
      given(:passport_product) { create :sync_passport_product }
      given(:partner) { ::EmployerPortal::Sync::Partner[company.remote_id] }
      given(:account) { ::EmployerPortal::Sync::Account[employee.remote_id] }
      given(:user) { ::EmployerPortal::Sync::User[account.user_id] }
      given(:kit1) { create :sync_kit, requisition: user.requisitions.first, flagged_status: "FLAGGED" }
      given(:kit2) { create :sync_kit, requisition: user.requisitions.first }
      before do
        partner.update passport_product: passport_product
        ::EmployerPortal::Sync.create_account_for_employee! employee
        travel_to now - 1.day do
          create :sync_question, kit: kit1, sub_group: "Symptoms", response: "Yes"
          create :sync_question, kit: kit1, question: "Temperature", response: "99.5ºF"
        end
        travel_to now do
          create :sync_question, kit: kit2, question: "Temperature", response: "100.4ºF"
        end
      end

      scenario "I see them in the Symptom Tracker widget" do
        visit_employee_edit
        within "#symptom-tracker:not(.bg-gray-100) tbody" do
          expect(page).to have_css("tr", count: 2)
          within "tr:nth-child(1)" do
            expect(page).to have_css("td:nth-child(1)", text: today.to_s)
            expect(page).not_to have_css("td:nth-child(2) svg")
            expect(page).to have_css("td:nth-child(3).text-red-600", text: "100.4ºF")
            expect(page).to have_css("td:nth-child(4)", text: "No")
            expect(page).to have_css("td:nth-child(5) a[href$='/employees/#{employee.uuid}/symptom_logs/#{today}']")
          end
          within "tr:nth-child(2)" do
            expect(page).to have_css("td:nth-child(1)", text: (today - 1).to_s)
            expect(page).to have_css("td:nth-child(2) svg")
            expect(page).to have_css("td:nth-child(3):not(.text-red-600)", text: "99.5ºF")
            expect(page).to have_css("td:nth-child(4)", text: "Yes")
            expect(page).to have_css("td:nth-child(5) a[href$='/employees/#{employee.uuid}/symptom_logs/#{today - 1}']")
          end
        end
      end
    end

    context "when employee daily checkup is Cleared" do
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
        within "#symptom-tracker:not(.bg-gray-100)" do
          expect(page).not_to have_css("tbody tr")
        end
        within "#testing-progress:not(.bg-gray-100)" do
          expect(page).to have_css(".bg-blue-400", count: 1)
          within "li:nth-child(1)" do
            expect(page).to have_css ".bg-blue-400"
            expect(page).to have_content "Not Registered"
          end
          expect(page).to have_css("a[href$='/employees/#{employee.uuid}/health_passport']", text: "Not Registered")
        end
        expect(page).to have_css("form#edit_employee_#{employee.id}")
        within "#action_buttons" do
          expect(page).to have_css "a", count: 1
          expect(page).to have_content "Contact not needed"
          expect(page).to have_content "Reminder not needed"
          expect(page).to have_link "Deactivate"
        end
      end
    end

    context "when employee testing is Cleared" do
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
        within "#symptom-tracker:not(.bg-gray-100)" do
          expect(page).not_to have_css("tbody tr")
        end
        within "#testing-progress:not(.bg-gray-100)" do
          expect(page).to have_css(".bg-blue-400", count: 1)
          within "li:nth-child(7)" do
            expect(page).to have_css ".bg-blue-400"
            expect(page).to have_content "Passport Complete"
          end
          expect(page).to have_css("a[href$='/employees/#{employee.uuid}/health_passport']", text: "Cleared")
        end
        expect(page).to have_css("form#edit_employee_#{employee.id}")
        within "#action_buttons" do
          expect(page).to have_css "a", count: 2
          expect(page).to have_content "Contact not needed"
          expect(page).to have_link "Send Reminder"
          expect(page).to have_link "Deactivate"
        end
      end
    end

    context "when employee testing is Inconclusive" do
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
        within "#symptom-tracker:not(.bg-gray-100)" do
          expect(page).not_to have_css("tbody tr")
        end
        within "#testing-progress:not(.bg-gray-100)" do
          expect(page).to have_css(".bg-blue-400", count: 1)
          within "li:nth-child(7)" do
            expect(page).to have_css ".bg-blue-400"
            expect(page).to have_content "Passport Complete"
          end
          expect(page).to have_css("a[href$='/employees/#{employee.uuid}/health_passport']", text: "Not Cleared")
        end
        expect(page).to have_css("form#edit_employee_#{employee.id}")
        within "#action_buttons" do
          expect(page).to have_css "a", count: 2
          expect(page).to have_content "Contact not needed"
          expect(page).to have_link "Send Reminder"
          expect(page).to have_link "Deactivate"
        end
      end
    end

    context "when my company plan has Daily Checkup disabled" do
      before do
        company.plan.update daily_checkup_enabled: false
        ::EmployerPortal::Sync.create_account_for_employee! employee
      end

      scenario "I don't see my employee Daily Checkup status" do
        visit_employee_edit
        within "#symptom-tracker.bg-gray-100" do
          expect(page).to have_css(".italic", text: "Feature not included in your current plan")
          within "tbody" do
            expect(page).to have_css("tr", count: 3)
            expect(page).to have_css("tr:nth-child(1) td:nth-child(1)", text: "2020-04-03")
            expect(page).to have_css("tr:nth-child(1) td:nth-child(3)", text: "100.2ºF")
            expect(page).to have_css("tr:nth-child(1) td:nth-child(4)", text: "No")
            expect(page).to have_css("tr:nth-child(2) td:nth-child(1)", text: "2020-03-31")
            expect(page).to have_css("tr:nth-child(2) td:nth-child(3)", text: "100.4ºF")
            expect(page).to have_css("tr:nth-child(2) td:nth-child(4)", text: "Yes")
            expect(page).to have_css("tr:nth-child(3) td:nth-child(1)", text: "2020-03-29")
            expect(page).to have_css("tr:nth-child(3) td:nth-child(3)", text: "99.7ºF")
            expect(page).to have_css("tr:nth-child(3) td:nth-child(4)", text: "No")
          end
        end
        within "#testing-progress:not(.bg-gray-100)" do
          expect(page).to have_css(".bg-blue-400", count: 1)
          within "li:nth-child(1)" do
            expect(page).to have_css ".bg-blue-400"
            expect(page).to have_content "Not Registered"
          end
          expect(page).to have_css("a[href$='/employees/#{employee.uuid}/health_passport']", text: "Not Registered")
        end
        expect(page).to have_css("form#edit_employee_#{employee.id}")
        within "#action_buttons" do
          expect(page).to have_css "a", count: 1
          expect(page).not_to have_content "Contact"
          expect(page).not_to have_content "Remind"
          expect(page).to have_link "Deactivate"
        end
      end
    end

    context "when my company plan has Health Passport disabled" do
      before do
        company.plan.update health_passport_enabled: false
        ::EmployerPortal::Sync.create_account_for_employee! employee
      end

      scenario "I don't see a link to the Health Passport" do
        visit_employee_edit
        within "#symptom-tracker:not(.bg-gray-100)" do
          expect(page).not_to have_css("tbody tr")
        end
        within "#testing-progress:not(.bg-gray-100)" do
          expect(page).to have_css(".bg-blue-400", count: 1)
          within "li:nth-child(1)" do
            expect(page).to have_css ".bg-blue-400"
            expect(page).to have_content "Not Registered"
          end
          expect(page).not_to have_css("a[href$='/employees/#{employee.uuid}/health_passport']")
        end
        expect(page).to have_css("form#edit_employee_#{employee.id}")
        within "#action_buttons" do
          expect(page).to have_css "a", count: 2
          expect(page).to have_content "Contact not needed"
          expect(page).to have_link "Send Reminder"
          expect(page).to have_link "Deactivate"
        end
      end
    end

    context "when my company plan has Testing disabled" do
      before do
        company.plan.update testing_enabled: false, health_passport_enabled: false
        ::EmployerPortal::Sync.create_account_for_employee! employee
      end

      scenario "I don't see my employee Testing status" do
        visit_employee_edit
        within "#symptom-tracker:not(.bg-gray-100)" do
          expect(page).not_to have_css("tbody tr")
        end
        within "#testing-progress.bg-gray-100" do
          expect(page).to have_css(".italic", text: "Feature not included in your current plan")
          expect(page).not_to have_css(".bg-blue-400")
          expect(page).not_to have_css("a[href$='/employees/#{employee.uuid}/health_passport']")
        end
        expect(page).to have_css("form#edit_employee_#{employee.id}")
        within "#action_buttons" do
          expect(page).to have_css "a", count: 2
          expect(page).to have_content "Contact not needed"
          expect(page).to have_link "Send Reminder"
          expect(page).to have_link "Deactivate"
        end
      end
    end
  end

  context "without sync" do
    scenario "I still edit my employee details" do
      visit_employee_edit
      within "#symptom-tracker.bg-gray-100" do
        expect(page).to have_css(".italic", text: "Temporarily unavailable, please come back later")
        within "tbody" do
          expect(page).to have_css("tr", count: 3)
          expect(page).to have_css("tr:nth-child(1) td:nth-child(1)", text: "2020-04-03")
          expect(page).to have_css("tr:nth-child(1) td:nth-child(3)", text: "100.2ºF")
          expect(page).to have_css("tr:nth-child(1) td:nth-child(4)", text: "No")
          expect(page).to have_css("tr:nth-child(2) td:nth-child(1)", text: "2020-03-31")
          expect(page).to have_css("tr:nth-child(2) td:nth-child(3)", text: "100.4ºF")
          expect(page).to have_css("tr:nth-child(2) td:nth-child(4)", text: "Yes")
          expect(page).to have_css("tr:nth-child(3) td:nth-child(1)", text: "2020-03-29")
          expect(page).to have_css("tr:nth-child(3) td:nth-child(3)", text: "99.7ºF")
          expect(page).to have_css("tr:nth-child(3) td:nth-child(4)", text: "No")
        end
      end
      within "#testing-progress.bg-gray-100" do
        expect(page).to have_css(".italic", text: "Temporarily unavailable, please come back later")
        expect(page).not_to have_css(".bg-blue-400")
        expect(page).not_to have_css("a[href$='/employees/#{employee.uuid}/health_passport']")
      end
      within "form#edit_employee_#{employee.id}" do
        fill_in "First Name", with: "SpongeBob"
        fill_in "Last Name", with: "SquarePants"
        fill_in "Email", with: "spongebob@example.com"
        fill_in "Phone Number", with: "123-456"
        select "New York", from: "State"
        click_button "Save changes"
      end
      expect(page).to have_css("[role=notice]", text: "Employee was updated successfully.")
      expect(page).not_to have_css("[role=alert]")
      expect(page).to have_css "a[href$='/edit']", count: 1
      within "a[href$='/employees/#{employee.uuid}/edit']" do
        expect(page).to have_css "div:nth-child(2)", text: "SpongeBob SquarePants"
        expect(page).to have_css "div:nth-child(3)", text: "NY"
      end
      visit_employee_edit
      within "form#edit_employee_#{employee.id}" do
        expect(page).to have_field("First Name", with: "SpongeBob")
        expect(page).to have_field("Last Name", with: "SquarePants")
        expect(page).to have_field("Email", with: "spongebob@example.com")
        expect(page).to have_field("Phone Number", with: "123-456")
        expect(page).to have_select "State", selected: "New York"
      end
    end

    scenario "I can't edit the employee with errors" do
      visit_employee_edit
      within "form#edit_employee_#{employee.id}" do
        fill_in "First Name", with: ""
        fill_in "Last Name", with: ""
        fill_in "Email", with: ""
        fill_in "Phone Number", with: ""
        select "", from: "State"
        click_button "Save changes"
      end
      expect(page).not_to have_css("[role=notice]")
      expect(page).to have_css("[role=alert]", text: "Please review errors and try submitting it again.")
      within "form#edit_employee_#{employee.id}" do
        is_expected.to have_form_errors(
          employee_first_name: "is not present",
          employee_last_name: "is not present",
          employee_email: "is not present",
          employee_phone: "is not present",
          employee_state: "is not present",
        )
      end
    end
  end

  def visit_employee_edit
    visit "/employees/#{employee.uuid}/edit"
    expect(page).to have_css "h1", text: "Employee Details"
  end
end
