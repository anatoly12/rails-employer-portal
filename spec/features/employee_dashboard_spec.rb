require "rails_helper"

feature "Employee dashboard" do
  include ApplicationHelpers

  before { sign_in_as_employer }

  describe "without any employee" do
    scenario "I see the welcome message but no employee" do
      visit "/"
      within ".blur-3 .container" do
        expect(page).to have_content "Welcome #{@employer.first_name}!"
      end
      expect(page).not_to have_css "a[href$='/edit']"
    end
  end

  describe "with one employee" do
    given(:company) { @employer.company }
    given!(:employee) { create :employee, company: company }
    given!(:from_another_company) { create :employee }
    given(:now) { Time.now }
    given(:today) { now.to_date }

    context "with sync connected", type: :sync do
      include SyncHelpers
      before do
        with_sync_connected
        ::EmployerPortal::Sync.create_partner_for_company! company
      end

      describe "when employee hasn't been synced yet" do
        scenario "I see my employee with default statuses" do
          visit "/"
          expect(page).not_to have_css ".blur-3 .container"
          within "#charts > div:nth-child(1)" do
            check_charts [["#1dd678", 0], ["#f35200", 0], ["#16a3e5", 100]]
          end
          within "#charts > div:nth-child(2)" do
            check_charts [["#1dd678", 0], ["#f35200", 0], ["#16a3e5", 100]]
          end
          within "a[href$='/employees/#{employee.uuid}/edit']" do
            expect(page).to have_css "div:nth-child(2)", text: "#{employee.first_name} #{employee.last_name}"
            expect(page).to have_css "div:nth-child(3)", text: employee.state
            expect(page).to have_css "div:nth-child(4).text-blue-600", text: "Did Not Submit"
            expect(page).to have_css "div:nth-child(5)", text: "Never"
            expect(page).to have_css "div:nth-child(6)", text: /\A\z/
            expect(page).not_to have_css "div:nth-child(6) button"
            expect(page).to have_css "div:nth-child(7).text-blue-600", text: "Not Registered"
            expect(page).to have_css "div:nth-child(8)", text: "Never"
            expect(page).to have_css "div:nth-child(9)", text: /\A\z/
            expect(page).to have_css "div:nth-child(10) svg"
          end
        end
      end

      describe "when employee daily checkup is Did Not Submit" do
        before { ::EmployerPortal::Sync.create_account_for_employee! employee }

        scenario "I see the Send Reminder button" do
          visit "/"
          expect(page).not_to have_css ".blur-3 .container"
          within "#charts > div:nth-child(1)" do
            check_charts [["#1dd678", 0], ["#f35200", 0], ["#16a3e5", 100]]
          end
          within "#charts > div:nth-child(2)" do
            check_charts [["#1dd678", 0], ["#f35200", 0], ["#16a3e5", 100]]
          end
          within "a[href$='/employees/#{employee.uuid}/edit']" do
            expect(page).to have_css "div:nth-child(2)", text: "#{employee.first_name} #{employee.last_name}"
            expect(page).to have_css "div:nth-child(3)", text: employee.state
            expect(page).to have_css "div:nth-child(4).text-blue-600", text: "Did Not Submit"
            expect(page).to have_css "div:nth-child(5)", text: "Never"
            expect(page).to have_css "div:nth-child(6) button", text: "Send Reminder"
            expect(page).to have_css "div:nth-child(7).text-blue-600", text: "Not Registered"
            expect(page).to have_css "div:nth-child(8)", text: "Never"
            expect(page).to have_css "div:nth-child(9)", text: /\A\z/
            expect(page).to have_css "div:nth-child(10) svg"
          end
        end

        scenario "I can't click on the Send Reminder button twice" do
          visit "/"
          expect(page).not_to have_css ".blur-3 .container"
          within "#charts > div:nth-child(1)" do
            check_charts [["#1dd678", 0], ["#f35200", 0], ["#16a3e5", 100]]
          end
          within "#charts > div:nth-child(2)" do
            check_charts [["#1dd678", 0], ["#f35200", 0], ["#16a3e5", 100]]
          end
          within "a[href$='/employees/#{employee.uuid}/edit']" do
            expect(page).to have_css "div:nth-child(2)", text: "#{employee.first_name} #{employee.last_name}"
            expect(page).to have_css "div:nth-child(3)", text: employee.state
            expect(page).to have_css "div:nth-child(4).text-blue-600", text: "Did Not Submit"
            expect(page).to have_css "div:nth-child(5)", text: "Never"
            expect(page).to have_css "div:nth-child(6) button", text: "Send Reminder"
            expect(page).to have_css "div:nth-child(7).text-blue-600", text: "Not Registered"
            expect(page).to have_css "div:nth-child(8)", text: "Never"
            expect(page).to have_css "div:nth-child(9)", text: /\A\z/
            expect(page).to have_css "div:nth-child(10) svg"
            click_button "Send Reminder"
          end
          expect(page).to have_css("[role=notice]", text: "Employee reminder was sent successfully.")
          expect(page).not_to have_css("[role=alert]")
          visit "/"
          expect(page).not_to have_css ".blur-3 .container"
          within "#charts > div:nth-child(1)" do
            check_charts [["#1dd678", 0], ["#f35200", 0], ["#16a3e5", 100]]
          end
          within "#charts > div:nth-child(2)" do
            check_charts [["#1dd678", 0], ["#f35200", 0], ["#16a3e5", 100]]
          end
          within "a[href$='/employees/#{employee.uuid}/edit']" do
            expect(page).to have_css "div:nth-child(2)", text: "#{employee.first_name} #{employee.last_name}"
            expect(page).to have_css "div:nth-child(3)", text: employee.state
            expect(page).to have_css "div:nth-child(4).text-blue-600", text: "Did Not Submit"
            expect(page).to have_css "div:nth-child(5)", text: "Never"
            expect(page).to have_css "div:nth-child(6)", text: "Reminder sent"
            expect(page).not_to have_css "div:nth-child(6) button"
            expect(page).to have_css "div:nth-child(7).text-blue-600", text: "Not Registered"
            expect(page).to have_css "div:nth-child(8)", text: "Never"
            expect(page).to have_css "div:nth-child(9)", text: /\A\z/
            expect(page).to have_css "div:nth-child(10) svg"
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

        scenario "I see the Contact button" do
          visit "/"
          expect(page).not_to have_css ".blur-3 .container"
          within "#charts > div:nth-child(1)" do
            check_charts [["#1dd678", 0], ["#f35200", 100], ["#16a3e5", 0]]
          end
          within "#charts > div:nth-child(2)" do
            check_charts [["#1dd678", 0], ["#f35200", 0], ["#16a3e5", 100]]
          end
          within "a[href$='/employees/#{employee.uuid}/edit']" do
            expect(page).to have_css "div:nth-child(2)", text: "#{employee.first_name} #{employee.last_name}"
            expect(page).to have_css "div:nth-child(3)", text: employee.state
            expect(page).to have_css "div:nth-child(4).text-red-600", text: "Not Cleared"
            expect(page).to have_css "div:nth-child(5)", text: today.to_s
            expect(page).to have_css "div:nth-child(6) button", text: "Contact"
            expect(page).to have_css "div:nth-child(7).text-blue-600", text: "Not Registered"
            expect(page).to have_css "div:nth-child(8)", text: "Never"
            expect(page).to have_css "div:nth-child(9)", text: /\A\z/
            expect(page).to have_css "div:nth-child(10) svg"
          end
        end

        scenario "I can't click on the Contact button twice" do
          visit "/"
          expect(page).not_to have_css ".blur-3 .container"
          within "#charts > div:nth-child(1)" do
            check_charts [["#1dd678", 0], ["#f35200", 100], ["#16a3e5", 0]]
          end
          within "#charts > div:nth-child(2)" do
            check_charts [["#1dd678", 0], ["#f35200", 0], ["#16a3e5", 100]]
          end
          within "a[href$='/employees/#{employee.uuid}/edit']" do
            expect(page).to have_css "div:nth-child(2)", text: "#{employee.first_name} #{employee.last_name}"
            expect(page).to have_css "div:nth-child(3)", text: employee.state
            expect(page).to have_css "div:nth-child(4).text-red-600", text: "Not Cleared"
            expect(page).to have_css "div:nth-child(5)", text: today.to_s
            expect(page).to have_css "div:nth-child(6) button", text: "Contact"
            expect(page).to have_css "div:nth-child(7).text-blue-600", text: "Not Registered"
            expect(page).to have_css "div:nth-child(8)", text: "Never"
            expect(page).to have_css "div:nth-child(9)", text: /\A\z/
            expect(page).to have_css "div:nth-child(10) svg"
            click_button "Contact"
          end
          expect(page).to have_css("[role=notice]", text: "Employee was contacted successfully.")
          expect(page).not_to have_css("[role=alert]")
          visit "/"
          expect(page).not_to have_css ".blur-3 .container"
          within "#charts > div:nth-child(1)" do
            check_charts [["#1dd678", 0], ["#f35200", 100], ["#16a3e5", 0]]
          end
          within "#charts > div:nth-child(2)" do
            check_charts [["#1dd678", 0], ["#f35200", 0], ["#16a3e5", 100]]
          end
          within "a[href$='/employees/#{employee.uuid}/edit']" do
            expect(page).to have_css "div:nth-child(2)", text: "#{employee.first_name} #{employee.last_name}"
            expect(page).to have_css "div:nth-child(3)", text: employee.state
            expect(page).to have_css "div:nth-child(4).text-red-600", text: "Not Cleared"
            expect(page).to have_css "div:nth-child(5)", text: today.to_s
            expect(page).to have_css "div:nth-child(6)", text: "Contacted"
            expect(page).not_to have_css "div:nth-child(6) button"
            expect(page).to have_css "div:nth-child(7).text-blue-600", text: "Not Registered"
            expect(page).to have_css "div:nth-child(8)", text: "Never"
            expect(page).to have_css "div:nth-child(9)", text: /\A\z/
            expect(page).to have_css "div:nth-child(10) svg"
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

        scenario "I see no action button" do
          visit "/"
          expect(page).not_to have_css ".blur-3 .container"
          within "#charts > div:nth-child(1)" do
            check_charts [["#1dd678", 100], ["#f35200", 0], ["#16a3e5", 0]]
          end
          within "#charts > div:nth-child(2)" do
            check_charts [["#1dd678", 0], ["#f35200", 0], ["#16a3e5", 100]]
          end
          within "a[href$='/employees/#{employee.uuid}/edit']" do
            expect(page).to have_css "div:nth-child(2)", text: "#{employee.first_name} #{employee.last_name}"
            expect(page).to have_css "div:nth-child(3)", text: employee.state
            expect(page).to have_css "div:nth-child(4).text-green-500", text: "Cleared"
            expect(page).to have_css "div:nth-child(5)", text: today.to_s
            expect(page).to have_css "div:nth-child(6)", text: /\A\z/
            expect(page).not_to have_css "div:nth-child(6) button"
            expect(page).to have_css "div:nth-child(7).text-blue-600", text: "Not Registered"
            expect(page).to have_css "div:nth-child(8)", text: "Never"
            expect(page).to have_css "div:nth-child(9)", text: /\A\z/
            expect(page).to have_css "div:nth-child(10) svg"
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

        scenario "I see the testing status in green" do
          visit "/"
          expect(page).not_to have_css ".blur-3 .container"
          within "#charts > div:nth-child(1)" do
            check_charts [["#1dd678", 0], ["#f35200", 0], ["#16a3e5", 100]]
          end
          within "#charts > div:nth-child(2)" do
            check_charts [["#1dd678", 100], ["#f35200", 0], ["#16a3e5", 0]]
          end
          within "a[href$='/employees/#{employee.uuid}/edit']" do
            expect(page).to have_css "div:nth-child(2)", text: "#{employee.first_name} #{employee.last_name}"
            expect(page).to have_css "div:nth-child(3)", text: employee.state
            expect(page).to have_css "div:nth-child(4).text-blue-600", text: "Did Not Submit"
            expect(page).to have_css "div:nth-child(5)", text: "Never"
            expect(page).to have_css "div:nth-child(6) button", text: "Send Reminder"
            expect(page).to have_css "div:nth-child(7).text-green-500", text: "Cleared"
            expect(page).to have_css "div:nth-child(8)", text: today.to_s
            expect(page).to have_css "div:nth-child(9)", text: /\A\z/
            expect(page).to have_css "div:nth-child(10) svg"
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

        scenario "I see the testing status in red" do
          visit "/"
          expect(page).not_to have_css ".blur-3 .container"
          within "#charts > div:nth-child(1)" do
            check_charts [["#1dd678", 0], ["#f35200", 0], ["#16a3e5", 100]]
          end
          within "#charts > div:nth-child(2)" do
            check_charts [["#1dd678", 0], ["#f35200", 100], ["#16a3e5", 0]]
          end
          within "a[href$='/employees/#{employee.uuid}/edit']" do
            expect(page).to have_css "div:nth-child(2)", text: "#{employee.first_name} #{employee.last_name}"
            expect(page).to have_css "div:nth-child(3)", text: employee.state
            expect(page).to have_css "div:nth-child(4).text-blue-600", text: "Did Not Submit"
            expect(page).to have_css "div:nth-child(5)", text: "Never"
            expect(page).to have_css "div:nth-child(6) button", text: "Send Reminder"
            expect(page).to have_css "div:nth-child(7).text-red-600", text: "Inconclusive"
            expect(page).to have_css "div:nth-child(8)", text: today.to_s
            expect(page).to have_css "div:nth-child(9)", text: /\A\z/
            expect(page).to have_css "div:nth-child(10) svg"
          end
        end
      end

      describe "when employee is deactivated" do
        before do
          ::EmployerPortal::Sync.create_account_for_employee! employee
          ::EmployerPortal::Sync::Account.find(
            id: employee.remote_id,
          ).update is_active: false
        end

        scenario "I see my employee just the same" do
          visit "/"
          expect(page).not_to have_css ".blur-3 .container"
          within "#charts > div:nth-child(1)" do
            check_charts [["#1dd678", 0], ["#f35200", 0], ["#16a3e5", 100]]
          end
          within "#charts > div:nth-child(2)" do
            check_charts [["#1dd678", 0], ["#f35200", 0], ["#16a3e5", 100]]
          end
          within "a[href$='/employees/#{employee.uuid}/edit']" do
            expect(page).to have_css "div:nth-child(2)", text: "#{employee.first_name} #{employee.last_name}"
            expect(page).to have_css "div:nth-child(3)", text: employee.state
            expect(page).to have_css "div:nth-child(4).text-blue-600", text: "Did Not Submit"
            expect(page).to have_css "div:nth-child(5)", text: "Never"
            expect(page).to have_css "div:nth-child(6) button", text: "Send Reminder"
            expect(page).to have_css "div:nth-child(7).text-blue-600", text: "Not Registered"
            expect(page).to have_css "div:nth-child(8)", text: "Never"
            expect(page).to have_css "div:nth-child(9)", text: /\A\z/
            expect(page).to have_css "div:nth-child(10) svg"
          end
        end
      end

      describe "when my company plan has Daily Checkup disabled" do
        before { company.plan.update daily_checkup_enabled: false }

        scenario "I don't see my employee Daily Checkup status" do
          visit "/"
          expect(page).not_to have_css ".blur-3 .container"
          within "#charts > div:nth-child(1)" do
            check_charts [["#718096", 20], ["#718096", 50], ["#718096", 30]]
          end
          within "#charts > div:nth-child(2)" do
            check_charts [["#1dd678", 0], ["#f35200", 0], ["#16a3e5", 100]]
          end
          within "a[href$='/employees/#{employee.uuid}/edit']" do
            expect(page).to have_css "div:nth-child(2)", text: "#{employee.first_name} #{employee.last_name}"
            expect(page).to have_css "div:nth-child(3)", text: employee.state
            expect(page).to have_css "div:nth-child(4).text-gray-600", text: "Did Not Submit"
            expect(page).to have_css "div:nth-child(5)", text: "N/A"
            expect(page).to have_css "div:nth-child(6)", text: /\A\z/
            expect(page).not_to have_css "div:nth-child(6) button"
            expect(page).to have_css "div:nth-child(7).text-blue-600", text: "Not Registered"
            expect(page).to have_css "div:nth-child(8)", text: "Never"
            expect(page).to have_css "div:nth-child(9)", text: /\A\z/
            expect(page).to have_css "div:nth-child(10) svg"
          end
        end
      end

      describe "when my company plan has Testing disabled" do
        before { company.plan.update testing_enabled: false, health_passport_enabled: false }

        scenario "I don't see my employee Testing status" do
          visit "/"
          expect(page).not_to have_css ".blur-3 .container"
          within "#charts > div:nth-child(1)" do
            check_charts [["#1dd678", 0], ["#f35200", 0], ["#16a3e5", 100]]
          end
          within "#charts > div:nth-child(2)" do
            check_charts [["#718096", 20], ["#718096", 50], ["#718096", 30]]
          end
          within "a[href$='/employees/#{employee.uuid}/edit']" do
            expect(page).to have_css "div:nth-child(2)", text: "#{employee.first_name} #{employee.last_name}"
            expect(page).to have_css "div:nth-child(3)", text: employee.state
            expect(page).to have_css "div:nth-child(4).text-blue-600", text: "Did Not Submit"
            expect(page).to have_css "div:nth-child(5)", text: "Never"
            expect(page).to have_css "div:nth-child(6)", text: /\A\z/
            expect(page).not_to have_css "div:nth-child(6) button"
            expect(page).to have_css "div:nth-child(7).text-gray-600", text: "Not Registered"
            expect(page).to have_css "div:nth-child(8)", text: "N/A"
            expect(page).to have_css "div:nth-child(9)", text: /\A\z/
            expect(page).to have_css "div:nth-child(10) svg"
          end
        end
      end
    end

    describe "without sync" do
      scenario "I still see my employee but statuses are disabled" do
        visit "/"
        expect(page).not_to have_css ".blur-3 .container"
        within "#charts > div:nth-child(1)" do
          check_charts [["#718096", 20], ["#718096", 50], ["#718096", 30]]
        end
        within "#charts > div:nth-child(2)" do
          check_charts [["#718096", 20], ["#718096", 50], ["#718096", 30]]
        end
        within "a[href$='/employees/#{employee.uuid}/edit']" do
          expect(page).to have_css "div:nth-child(2)", text: "#{employee.first_name} #{employee.last_name}"
          expect(page).to have_css "div:nth-child(3)", text: employee.state
          expect(page).to have_css "div:nth-child(4).text-gray-600", text: "Did Not Submit"
          expect(page).to have_css "div:nth-child(5)", text: "N/A"
          expect(page).to have_css "div:nth-child(6)", text: /\A\z/
          expect(page).not_to have_css "div:nth-child(6) button"
          expect(page).to have_css "div:nth-child(7).text-gray-600", text: "Not Registered"
          expect(page).to have_css "div:nth-child(8)", text: "N/A"
          expect(page).to have_css "div:nth-child(9)", text: /\A\z/
          expect(page).to have_css "div:nth-child(10) svg"
        end
      end
    end
  end

  def check_charts(array)
    charts = page.all ".chart"
    array.each_with_index do |item, index|
      chart = charts[index]
      expect(chart["data-color"]).to eql item[0]
      expect(chart["data-percent"]).to eql item[1].to_s
    end
  end
end
