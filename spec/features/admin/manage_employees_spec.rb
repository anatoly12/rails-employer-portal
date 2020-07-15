require "rails_helper"

feature "Manage employees" do
  let!(:employee1) { create :employee }
  let!(:employee2) { create :employee }
  let(:now) { Time.now }
  let(:today) { now.to_date }
  before { sign_in_as_admin_user }

  context "when sync is connected", type: :sync do
    before { with_sync_connected }

    scenario "I can list and filter employees" do
      click_link "Employees"
      within "table tbody" do
        expect(page).to have_css "tr", count: 2
        within "tr:nth-child(1)" do
          expect(page).to have_css "td:nth-child(1)", text: employee2.company.name
          expect(page).to have_css "td:nth-child(3)", text: "#{employee2.first_name} #{employee2.last_name}"
          expect(page).to have_css "td:nth-child(4)", text: employee2.email
          expect(page).to have_css "td:nth-child(5) a[title='Sync failed, click to retry']"
          expect(page).to have_css "td:nth-child(6)", text: "Did Not Submit"
          expect(page).to have_css "td:nth-child(7)", text: "Not Registered"
        end
        within "tr:nth-child(2)" do
          expect(page).to have_css "td:nth-child(1)", text: employee1.company.name
          expect(page).to have_css "td:nth-child(3)", text: "#{employee1.first_name} #{employee1.last_name}"
          expect(page).to have_css "td:nth-child(4)", text: employee1.email
          expect(page).to have_css "td:nth-child(5) a[title='Sync failed, click to retry']"
          expect(page).to have_css "td:nth-child(6)", text: "Did Not Submit"
          expect(page).to have_css "td:nth-child(7)", text: "Not Registered"
          expect do
            click_link "Sync failed, click to retry"
          end.to have_enqueued_job(CreateAccountForEmployeeJob).exactly(:once)
        end
      end
      expect(page).to have_css("[role=notice]", text: "A new background job was enqueued. Please wait at least 5 minutes before retrying sync for this employee.")
      expect(page).not_to have_css("[role=alert]")
      ::EmployerPortal::Sync.create_partner_for_company! employee1.company
      ::EmployerPortal::Sync.create_account_for_employee! employee1
      visit current_path
      within "table tbody" do
        expect(page).to have_css "tr", count: 2
        within "tr:nth-child(1)" do
          expect(page).to have_css "td:nth-child(1)", text: employee2.company.name
          expect(page).to have_css "td:nth-child(3)", text: "#{employee2.first_name} #{employee2.last_name}"
          expect(page).to have_css "td:nth-child(4)", text: employee2.email
          expect(page).to have_css "td:nth-child(5) a[title='Sync failed, click to retry']"
          expect(page).to have_css "td:nth-child(6)", text: "Did Not Submit"
          expect(page).to have_css "td:nth-child(7)", text: "Not Registered"
        end
        within "tr:nth-child(2)" do
          expect(page).to have_css "td:nth-child(1)", text: employee1.company.name
          expect(page).to have_css "td:nth-child(3)", text: "#{employee1.first_name} #{employee1.last_name}"
          expect(page).to have_css "td:nth-child(4)", text: employee1.email
          expect(page).to have_css "td:nth-child(5) a[title='Linked to account ##{employee1.remote_id}']"
          expect(page).to have_css "td:nth-child(6)", text: "Did Not Submit"
          expect(page).to have_css "td:nth-child(7)", text: "Not Registered"
        end
      end
      click_link "Filters"
      within "#new_filters" do
        select employee1.company.name, from: "Company"
        click_button "Search"
      end
      within "table tbody" do
        expect(page).to have_css "tr", count: 1
        expect(page).to have_css "td:nth-child(3)", text: "#{employee1.first_name} #{employee1.last_name}"
      end
      within "#new_filters" do
        select "", from: "Company"
        select "Not synced", from: "Sync status"
        click_button "Search"
      end
      within "table tbody" do
        expect(page).to have_css "tr", count: 1
        expect(page).to have_css "td:nth-child(3)", text: "#{employee2.first_name} #{employee2.last_name}"
      end
      within "#new_filters" do
        select "", from: "Sync status"
        fill_in "Full name contains", with: "#{employee1.first_name} #{employee1.last_name}"
        click_button "Search"
      end
      within "table tbody" do
        expect(page).to have_css "tr", count: 1
        expect(page).to have_css "td:nth-child(3)", text: "#{employee1.first_name} #{employee1.last_name}"
      end
      within "#new_filters" do
        fill_in "Full name contains", with: ""
        fill_in "Email contains", with: employee2.email
        click_button "Search"
      end
      within "table tbody" do
        expect(page).to have_css "tr", count: 1
        expect(page).to have_css "td:nth-child(3)", text: "#{employee2.first_name} #{employee2.last_name}"
      end
      ::EmployerPortal::Sync::Covid19DailyCheckupStatus.find_or_create(
        daily_checkup_status_code: 2,
      ) { |status| status.daily_checkup_status = "Not Cleared" }
      ::EmployerPortal::Sync::Covid19DailyCheckup.create(
        account_id: employee1.remote_id,
        daily_checkup_status_code: 2,
        checkup_date: today,
      )
      ::EmployerPortal::Sync::Covid19Evaluation.create(
        account_id: employee1.remote_id,
        status: 1,
        updated_at: now,
      )
      within "#new_filters" do
        fill_in "Email contains", with: ""
        select "Not Cleared", from: "Daily checkup status"
        click_button "Search"
      end
      within "table tbody" do
        expect(page).to have_css "tr", count: 1
        expect(page).to have_css "td:nth-child(3)", text: "#{employee1.first_name} #{employee1.last_name}"
        expect(page).to have_css "td:nth-child(6)", text: "Not Cleared"
        expect(page).to have_css "td:nth-child(7)", text: "Cleared"
      end
      within "#new_filters" do
        select "Did Not Submit", from: "Daily checkup status"
        click_button "Search"
      end
      within "table tbody" do
        expect(page).to have_css "tr", count: 1
        expect(page).to have_css "td:nth-child(3)", text: "#{employee2.first_name} #{employee2.last_name}"
        expect(page).to have_css "td:nth-child(6)", text: "Did Not Submit"
        expect(page).to have_css "td:nth-child(7)", text: "Not Registered"
      end
      within "#new_filters" do
        select "", from: "Daily checkup status"
        select "Cleared", from: "Testing status"
        click_button "Search"
      end
      within "table tbody" do
        expect(page).to have_css "tr", count: 1
        expect(page).to have_css "td:nth-child(3)", text: "#{employee1.first_name} #{employee1.last_name}"
        expect(page).to have_css "td:nth-child(6)", text: "Not Cleared"
        expect(page).to have_css "td:nth-child(7)", text: "Cleared"
      end
      within "#new_filters" do
        select "Not Registered", from: "Testing status"
        click_button "Search"
      end
      within "table tbody" do
        expect(page).to have_css "tr", count: 1
        expect(page).to have_css "td:nth-child(3)", text: "#{employee2.first_name} #{employee2.last_name}"
        expect(page).to have_css "td:nth-child(6)", text: "Did Not Submit"
        expect(page).to have_css "td:nth-child(7)", text: "Not Registered"
      end
    end
  end
end
