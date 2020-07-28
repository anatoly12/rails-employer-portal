require "rails_helper"

feature "Employee dashboard" do
  given(:company) { create :company }
  given(:employer) { create :employer, company: company }
  before { sign_in_as_employer employer }

  context "without any employee" do
    context "when sync is connected", type: :sync do
      before { with_sync_connected }

      scenario "I see the welcome message but no employee" do
        visit "/"
        within ".blur-3 .container" do
          expect(page).to have_content "Welcome #{employer.first_name}!"
        end
        within "#charts > div:nth-child(1)" do
          is_expected.to have_charts [
                                       { color: "#1dd678", count: 0, total: 0, percent: 0 },
                                       { color: "#f35200", count: 0, total: 0, percent: 0 },
                                       { color: "#16a3e5", count: 0, total: 0, percent: 0 },
                                     ]
        end
        within "#charts > div:nth-child(2)" do
          is_expected.to have_charts [
                                       { color: "#1dd678", count: 0, total: 0, percent: 0 },
                                       { color: "#f35200", count: 0, total: 0, percent: 0 },
                                       { color: "#16a3e5", count: 0, total: 0, percent: 0 },
                                     ]
        end
        expect(page).not_to have_css "a[href$='/edit']"
      end
    end

    context "when sync is NOT connected" do
      scenario "I see the welcome message but no employee" do
        visit "/"
        within ".blur-3 .container" do
          expect(page).to have_content "Welcome #{employer.first_name}!"
        end
        within "#charts > div:nth-child(1)" do
          is_expected.to have_charts [
                                       { color: "#718096", count: 20, total: 100, percent: 20 },
                                       { color: "#718096", count: 50, total: 100, percent: 50 },
                                       { color: "#718096", count: 30, total: 100, percent: 30 },
                                     ]
        end
        within "#charts > div:nth-child(2)" do
          is_expected.to have_charts [
                                       { color: "#718096", count: 20, total: 100, percent: 20 },
                                       { color: "#718096", count: 50, total: 100, percent: 50 },
                                       { color: "#718096", count: 30, total: 100, percent: 30 },
                                     ]
        end
        expect(page).not_to have_css "a[href$='/edit']"
      end
    end
  end

  context "with one employee" do
    given!(:employee) { create :employee, company: company }
    given!(:from_another_company) { create :employee }
    given(:now) { Time.now }
    given(:today) { now.to_date }

    context "when sync is connected", type: :sync do
      before do
        with_sync_connected
        ::EmployerPortal::Sync.create_partner_for_company! company
      end

      context "when employee hasn't been synced yet" do
        scenario "I see my employee with default statuses" do
          visit "/"
          expect(page).not_to have_css ".blur-3 .container"
          within "#charts > div:nth-child(1)" do
            is_expected.to have_charts [
                                         { color: "#1dd678", count: 0, total: 1, percent: 0 },
                                         { color: "#f35200", count: 0, total: 1, percent: 0 },
                                         { color: "#16a3e5", count: 1, total: 1, percent: 100 },
                                       ]
          end
          within "#charts > div:nth-child(2)" do
            is_expected.to have_charts [
                                         { color: "#1dd678", count: 0, total: 1, percent: 0 },
                                         { color: "#f35200", count: 0, total: 1, percent: 0 },
                                         { color: "#16a3e5", count: 1, total: 1, percent: 100 },
                                       ]
          end
          expect(page).to have_css "a[href$='/edit']", count: 1
          within "a[href='/employees/#{employee.uuid}/edit']" do
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

      context "when employee daily checkup is Did Not Submit" do
        before { ::EmployerPortal::Sync.create_account_for_employee! employee }

        scenario "I see the Send Reminder button" do
          visit "/"
          expect(page).not_to have_css ".blur-3 .container"
          within "#charts > div:nth-child(1)" do
            is_expected.to have_charts [
                                         { color: "#1dd678", count: 0, total: 1, percent: 0 },
                                         { color: "#f35200", count: 0, total: 1, percent: 0 },
                                         { color: "#16a3e5", count: 1, total: 1, percent: 100 },
                                       ]
          end
          within "#charts > div:nth-child(2)" do
            is_expected.to have_charts [
                                         { color: "#1dd678", count: 0, total: 1, percent: 0 },
                                         { color: "#f35200", count: 0, total: 1, percent: 0 },
                                         { color: "#16a3e5", count: 1, total: 1, percent: 100 },
                                       ]
          end
          expect(page).to have_css "a[href$='/edit']", count: 1
          within "a[href='/employees/#{employee.uuid}/edit']" do
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
          expect {
            click_button "Send Reminder"
          }.to have_enqueued_job(EmailTriggerJob).with(
            EmailTemplate::TRIGGER_EMPLOYEE_REMINDER,
            employee.uuid,
          )
          expect(page).to have_css("[role=notice]", text: "Employee reminder was sent successfully.")
          expect(page).not_to have_css("[role=alert]")
          visit "/"
          expect(page).not_to have_css ".blur-3 .container"
          within "#charts > div:nth-child(1)" do
            is_expected.to have_charts [
                                         { color: "#1dd678", count: 0, total: 1, percent: 0 },
                                         { color: "#f35200", count: 0, total: 1, percent: 0 },
                                         { color: "#16a3e5", count: 1, total: 1, percent: 100 },
                                       ]
          end
          within "#charts > div:nth-child(2)" do
            is_expected.to have_charts [
                                         { color: "#1dd678", count: 0, total: 1, percent: 0 },
                                         { color: "#f35200", count: 0, total: 1, percent: 0 },
                                         { color: "#16a3e5", count: 1, total: 1, percent: 100 },
                                       ]
          end
          expect(page).to have_css "a[href$='/edit']", count: 1
          within "a[href='/employees/#{employee.uuid}/edit']" do
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

      context "when employee daily checkup is Not Cleared" do
        before do
          ::EmployerPortal::Sync.create_account_for_employee! employee
          ::EmployerPortal::Sync::Covid19DailyCheckupStatus.find_or_create(
            daily_checkup_status_code: 2,
          ) { |status| status.daily_checkup_status = "Not Cleared" }
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
            is_expected.to have_charts [
                                         { color: "#1dd678", count: 0, total: 1, percent: 0 },
                                         { color: "#f35200", count: 1, total: 1, percent: 100 },
                                         { color: "#16a3e5", count: 0, total: 1, percent: 0 },
                                       ]
          end
          within "#charts > div:nth-child(2)" do
            is_expected.to have_charts [
                                         { color: "#1dd678", count: 0, total: 1, percent: 0 },
                                         { color: "#f35200", count: 0, total: 1, percent: 0 },
                                         { color: "#16a3e5", count: 1, total: 1, percent: 100 },
                                       ]
          end
          expect(page).to have_css "a[href$='/edit']", count: 1
          within "a[href='/employees/#{employee.uuid}/edit']" do
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
          expect {
            click_button "Contact"
          }.to have_enqueued_job(EmailTriggerJob).with(
            EmailTemplate::TRIGGER_EMPLOYEE_CONTACT,
            employee.uuid,
          )
          expect(page).to have_css("[role=notice]", text: "Employee was contacted successfully.")
          expect(page).not_to have_css("[role=alert]")
          visit "/"
          expect(page).not_to have_css ".blur-3 .container"
          within "#charts > div:nth-child(1)" do
            is_expected.to have_charts [
                                         { color: "#1dd678", count: 0, total: 1, percent: 0 },
                                         { color: "#f35200", count: 1, total: 1, percent: 100 },
                                         { color: "#16a3e5", count: 0, total: 1, percent: 0 },
                                       ]
          end
          within "#charts > div:nth-child(2)" do
            is_expected.to have_charts [
                                         { color: "#1dd678", count: 0, total: 1, percent: 0 },
                                         { color: "#f35200", count: 0, total: 1, percent: 0 },
                                         { color: "#16a3e5", count: 1, total: 1, percent: 100 },
                                       ]
          end
          expect(page).to have_css "a[href$='/edit']", count: 1
          within "a[href='/employees/#{employee.uuid}/edit']" do
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

      context "when employee daily checkup was Not Cleared yesterday" do
        before do
          ::EmployerPortal::Sync.create_account_for_employee! employee
          ::EmployerPortal::Sync::Covid19DailyCheckupStatus.find_or_create(
            daily_checkup_status_code: 2,
          ) { |status| status.daily_checkup_status = "Not Cleared" }
          ::EmployerPortal::Sync::Covid19DailyCheckup.create(
            account_id: employee.remote_id,
            daily_checkup_status_code: 2,
            checkup_date: today - 1,
          )
        end

        scenario "the daily checkup status stays Not Cleared" do
          visit "/"
          expect(page).not_to have_css ".blur-3 .container"
          within "#charts > div:nth-child(1)" do
            is_expected.to have_charts [
                                         { color: "#1dd678", count: 0, total: 1, percent: 0 },
                                         { color: "#f35200", count: 1, total: 1, percent: 100 },
                                         { color: "#16a3e5", count: 0, total: 1, percent: 0 },
                                       ]
          end
          within "#charts > div:nth-child(2)" do
            is_expected.to have_charts [
                                         { color: "#1dd678", count: 0, total: 1, percent: 0 },
                                         { color: "#f35200", count: 0, total: 1, percent: 0 },
                                         { color: "#16a3e5", count: 1, total: 1, percent: 100 },
                                       ]
          end
          expect(page).to have_css "a[href$='/edit']", count: 1
          within "a[href='/employees/#{employee.uuid}/edit']" do
            expect(page).to have_css "div:nth-child(2)", text: "#{employee.first_name} #{employee.last_name}"
            expect(page).to have_css "div:nth-child(3)", text: employee.state
            expect(page).to have_css "div:nth-child(4).text-red-600", text: "Not Cleared"
            expect(page).to have_css "div:nth-child(5)", text: (today - 1).to_s
            expect(page).to have_css "div:nth-child(6) button", text: "Contact"
            expect(page).to have_css "div:nth-child(7).text-blue-600", text: "Not Registered"
            expect(page).to have_css "div:nth-child(8)", text: "Never"
            expect(page).to have_css "div:nth-child(9)", text: /\A\z/
            expect(page).to have_css "div:nth-child(10) svg"
          end
        end
      end

      context "when employee daily checkup is Cleared" do
        before do
          ::EmployerPortal::Sync.create_account_for_employee! employee
          ::EmployerPortal::Sync::Covid19DailyCheckupStatus.find_or_create(
            daily_checkup_status_code: 1,
          ) { |status| status.daily_checkup_status = "Cleared" }
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
            is_expected.to have_charts [
                                         { color: "#1dd678", count: 1, total: 1, percent: 100 },
                                         { color: "#f35200", count: 0, total: 1, percent: 0 },
                                         { color: "#16a3e5", count: 0, total: 1, percent: 0 },
                                       ]
          end
          within "#charts > div:nth-child(2)" do
            is_expected.to have_charts [
                                         { color: "#1dd678", count: 0, total: 1, percent: 0 },
                                         { color: "#f35200", count: 0, total: 1, percent: 0 },
                                         { color: "#16a3e5", count: 1, total: 1, percent: 100 },
                                       ]
          end
          expect(page).to have_css "a[href$='/edit']", count: 1
          within "a[href='/employees/#{employee.uuid}/edit']" do
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

      context "when employee daily checkup was Cleared yesterday" do
        before do
          ::EmployerPortal::Sync.create_account_for_employee! employee
          ::EmployerPortal::Sync::Covid19DailyCheckupStatus.find_or_create(
            daily_checkup_status_code: 1,
          ) { |status| status.daily_checkup_status = "Cleared" }
          ::EmployerPortal::Sync::Covid19DailyCheckup.create(
            account_id: employee.remote_id,
            daily_checkup_status_code: 1,
            checkup_date: today - 1,
          )
        end

        scenario "the daily checkup status becomes Did Not Submit" do
          visit "/"
          expect(page).not_to have_css ".blur-3 .container"
          within "#charts > div:nth-child(1)" do
            is_expected.to have_charts [
                                         { color: "#1dd678", count: 0, total: 1, percent: 0 },
                                         { color: "#f35200", count: 0, total: 1, percent: 0 },
                                         { color: "#16a3e5", count: 1, total: 1, percent: 100 },
                                       ]
          end
          within "#charts > div:nth-child(2)" do
            is_expected.to have_charts [
                                         { color: "#1dd678", count: 0, total: 1, percent: 0 },
                                         { color: "#f35200", count: 0, total: 1, percent: 0 },
                                         { color: "#16a3e5", count: 1, total: 1, percent: 100 },
                                       ]
          end
          expect(page).to have_css "a[href$='/edit']", count: 1
          within "a[href='/employees/#{employee.uuid}/edit']" do
            expect(page).to have_css "div:nth-child(2)", text: "#{employee.first_name} #{employee.last_name}"
            expect(page).to have_css "div:nth-child(3)", text: employee.state
            expect(page).to have_css "div:nth-child(4).text-blue-600", text: "Did Not Submit"
            expect(page).to have_css "div:nth-child(5)", text: (today - 1).to_s
            expect(page).to have_css "div:nth-child(6) button", text: "Send Reminder"
            expect(page).to have_css "div:nth-child(7).text-blue-600", text: "Not Registered"
            expect(page).to have_css "div:nth-child(8)", text: "Never"
            expect(page).to have_css "div:nth-child(9)", text: /\A\z/
            expect(page).to have_css "div:nth-child(10) svg"
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

        scenario "I see the testing status in green" do
          visit "/"
          expect(page).not_to have_css ".blur-3 .container"
          within "#charts > div:nth-child(1)" do
            is_expected.to have_charts [
                                         { color: "#1dd678", count: 0, total: 1, percent: 0 },
                                         { color: "#f35200", count: 0, total: 1, percent: 0 },
                                         { color: "#16a3e5", count: 1, total: 1, percent: 100 },
                                       ]
          end
          within "#charts > div:nth-child(2)" do
            is_expected.to have_charts [
                                         { color: "#1dd678", count: 1, total: 1, percent: 100 },
                                         { color: "#f35200", count: 0, total: 1, percent: 0 },
                                         { color: "#16a3e5", count: 0, total: 1, percent: 0 },
                                       ]
          end
          expect(page).to have_css "a[href$='/edit']", count: 1
          within "a[href='/employees/#{employee.uuid}/edit']" do
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

      context "when employee testing is Inconclusive" do
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
            is_expected.to have_charts [
                                         { color: "#1dd678", count: 0, total: 1, percent: 0 },
                                         { color: "#f35200", count: 0, total: 1, percent: 0 },
                                         { color: "#16a3e5", count: 1, total: 1, percent: 100 },
                                       ]
          end
          within "#charts > div:nth-child(2)" do
            is_expected.to have_charts [
                                         { color: "#1dd678", count: 0, total: 1, percent: 0 },
                                         { color: "#f35200", count: 1, total: 1, percent: 100 },
                                         { color: "#16a3e5", count: 0, total: 1, percent: 0 },
                                       ]
          end
          expect(page).to have_css "a[href$='/edit']", count: 1
          within "a[href='/employees/#{employee.uuid}/edit']" do
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

      context "when employee has uploaded a selfie" do
        before do
          ::EmployerPortal::Sync.create_account_for_employee! employee
          ::EmployerPortal::Sync::Identity.create(
            account_id: employee.remote_id,
            selfie_s3_key: "dev/health_modules/identities/109/selfie",
            consented_at: now,
          )
        end

        context "when AWS is connected", type: :aws do
          before { with_aws_connected }

          scenario "I see it as my employee profile picture" do
            visit "/"
            expect(page).to have_css "a[href$='/edit']", count: 1
            within "a[href='/employees/#{employee.uuid}/edit']" do
              img = page.find "div:nth-child(1) img"
              expect(img["src"]).to include("s3.amazonaws.com/dev/health_modules/identities/109/selfie")
            end
          end
        end

        context "when AWS is NOT connected" do
          scenario "I see it as my employee profile picture" do
            visit "/"
            expect(page).to have_css "a[href$='/edit']", count: 1
            within "a[href='/employees/#{employee.uuid}/edit']" do
              expect(page).not_to have_css "div:nth-child(1) img"
            end
          end
        end
      end

      context "when employee is deactivated" do
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
            is_expected.to have_charts [
                                         { color: "#1dd678", count: 0, total: 1, percent: 0 },
                                         { color: "#f35200", count: 0, total: 1, percent: 0 },
                                         { color: "#16a3e5", count: 1, total: 1, percent: 100 },
                                       ]
          end
          within "#charts > div:nth-child(2)" do
            is_expected.to have_charts [
                                         { color: "#1dd678", count: 0, total: 1, percent: 0 },
                                         { color: "#f35200", count: 0, total: 1, percent: 0 },
                                         { color: "#16a3e5", count: 1, total: 1, percent: 100 },
                                       ]
          end
          expect(page).to have_css "a[href$='/edit']", count: 1
          within "a[href='/employees/#{employee.uuid}/edit']" do
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

      context "when my company plan has Daily Checkup disabled" do
        before { company.plan.update daily_checkup_enabled: false }

        scenario "I don't see my employee Daily Checkup status" do
          visit "/"
          expect(page).not_to have_css ".blur-3 .container"
          within "#charts > div:nth-child(1)" do
            is_expected.to have_charts [
                                         { color: "#718096", count: 20, total: 100, percent: 20 },
                                         { color: "#718096", count: 50, total: 100, percent: 50 },
                                         { color: "#718096", count: 30, total: 100, percent: 30 },
                                       ]
          end
          within "#charts > div:nth-child(2)" do
            is_expected.to have_charts [
                                         { color: "#1dd678", count: 0, total: 1, percent: 0 },
                                         { color: "#f35200", count: 0, total: 1, percent: 0 },
                                         { color: "#16a3e5", count: 1, total: 1, percent: 100 },
                                       ]
          end
          expect(page).to have_css "a[href$='/edit']", count: 1
          within "a[href='/employees/#{employee.uuid}/edit']" do
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

      context "when my company plan has Testing disabled" do
        before { company.plan.update testing_enabled: false, health_passport_enabled: false }

        scenario "I don't see my employee Testing status" do
          visit "/"
          expect(page).not_to have_css ".blur-3 .container"
          within "#charts > div:nth-child(1)" do
            is_expected.to have_charts [
                                         { color: "#1dd678", count: 0, total: 1, percent: 0 },
                                         { color: "#f35200", count: 0, total: 1, percent: 0 },
                                         { color: "#16a3e5", count: 1, total: 1, percent: 100 },
                                       ]
          end
          within "#charts > div:nth-child(2)" do
            is_expected.to have_charts [
                                         { color: "#718096", count: 20, total: 100, percent: 20 },
                                         { color: "#718096", count: 50, total: 100, percent: 50 },
                                         { color: "#718096", count: 30, total: 100, percent: 30 },
                                       ]
          end
          expect(page).to have_css "a[href$='/edit']", count: 1
          within "a[href='/employees/#{employee.uuid}/edit']" do
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

    context "when sync is NOT connected" do
      scenario "I still see my employee but statuses are disabled" do
        visit "/"
        expect(page).not_to have_css ".blur-3 .container"
        within "#charts > div:nth-child(1)" do
          is_expected.to have_charts [
                                       { color: "#718096", count: 20, total: 100, percent: 20 },
                                       { color: "#718096", count: 50, total: 100, percent: 50 },
                                       { color: "#718096", count: 30, total: 100, percent: 30 },
                                     ]
        end
        within "#charts > div:nth-child(2)" do
          is_expected.to have_charts [
                                       { color: "#718096", count: 20, total: 100, percent: 20 },
                                       { color: "#718096", count: 50, total: 100, percent: 50 },
                                       { color: "#718096", count: 30, total: 100, percent: 30 },
                                     ]
        end
        expect(page).to have_css "a[href$='/edit']", count: 1
        within "a[href='/employees/#{employee.uuid}/edit']" do
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

  context "with multiple employees", type: :sync do
    given!(:alice) { create :employee, first_name: "Alice", company: company }
    given!(:bob) { create :employee, first_name: "Bob", company: company }
    before do
      with_sync_connected
      ::EmployerPortal::Sync.create_partner_for_company! company
      ::EmployerPortal::Sync.create_account_for_employee! alice
      ::EmployerPortal::Sync.create_account_for_employee! bob
    end

    scenario "I can apply filters and change sorting order" do
      visit "/"
      expect(page).not_to have_css ".blur-3 .container"
      within "#charts > div:nth-child(1)" do
        is_expected.to have_charts [
                                     { color: "#1dd678", count: 0, total: 2, percent: 0 },
                                     { color: "#f35200", count: 0, total: 2, percent: 0 },
                                     { color: "#16a3e5", count: 2, total: 2, percent: 100 },
                                   ]
      end
      within "#charts > div:nth-child(2)" do
        is_expected.to have_charts [
                                     { color: "#1dd678", count: 0, total: 2, percent: 0 },
                                     { color: "#f35200", count: 0, total: 2, percent: 0 },
                                     { color: "#16a3e5", count: 2, total: 2, percent: 100 },
                                   ]
      end
      is_expected.to have_employees alice, bob
      click_link "Employee Name"
      is_expected.to have_employees bob, alice
      fill_in "filters_full_name_contains", with: "LIC"
      click_button "filters_submit"
      is_expected.to have_employees alice
      fill_in "filters_full_name_contains", with: "BOB "
      click_button "filters_submit"
      is_expected.to have_employees bob
    end
  end
end
