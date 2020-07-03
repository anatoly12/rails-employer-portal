require "rails_helper"

feature "Manage employers" do
  include AdminHelpers
  include SyncHelpers
  given!(:company) { create :company }
  before { sign_in_as_admin_user }

  scenario "I can add a new employer" do
    click_link "Employers"
    click_link "Add a new employer"
    within("#new_employer") do
      select company.name, from: "Company"
      select "Super admin", from: "Role"
      fill_in "First name", with: Faker::Name.first_name
      fill_in "Last name", with: Faker::Name.last_name
      fill_in "Email", with: Faker::Internet.unique.safe_email
      new_password = Faker::Internet.password
      fill_in "Password", with: new_password
      expect {
        click_button "Create"
      }.to have_enqueued_job(EmailTriggerJob).with(
        "employer_new",
        instance_of(Integer),
        "password" => new_password,
      )
    end
    expect(page).to have_css("[role=notice]", text: "Employer was created successfully.")
    expect(page).not_to have_css("[role=alert]")
  end

  scenario "I can't add a new employer with errors" do
    click_link "Employers"
    click_link "Add a new employer"
    within "#new_employer" do
      click_button "Create"
    end
    expect(page).not_to have_css "[role=notice]"
    expect(page).to have_css "[role=alert]", text: "Please review errors and try submitting it again."
    within "#new_employer" do
      expect_form_errors(
        employer_company_id: "is not present",
        employer_role: "is not present",
        employer_first_name: "is not present",
        employer_last_name: "is not present",
        employer_email: "is not present",
        employer_password: "is not present",
      )
    end
  end

  context "with existing employers" do
    let!(:employer1) { create :employer }
    let!(:employer2) { create :employer }

    scenario "I can list and filter employers" do
      click_link "Employers"
      within "table tbody" do
        expect(page).to have_css "tr", count: 2
        within "tr:nth-child(1)" do
          expect(page).to have_css "td", text: employer2.company.name
          expect(page).to have_css "td", text: employer2.first_name
          expect(page).to have_css "td", text: employer2.last_name
          expect(page).to have_css "td", text: employer2.email
          expect(page).to have_css "td", text: "Super admin"
        end
        within "tr:nth-child(2)" do
          expect(page).to have_css "td", text: employer1.company.name
          expect(page).to have_css "td", text: employer1.first_name
          expect(page).to have_css "td", text: employer1.last_name
          expect(page).to have_css "td", text: employer1.email
          expect(page).to have_css "td", text: "Super admin"
        end
      end
      click_link "Filters"
      within "#new_filters" do
        select employer1.company.name, from: "Company"
        click_button "Search"
      end
      within "table tbody" do
        expect(page).to have_css "tr", count: 1
        expect(page).to have_css "td", text: employer1.company.name
        expect(page).to have_css "td", text: employer1.first_name
        expect(page).to have_css "td", text: employer1.last_name
        expect(page).to have_css "td", text: employer1.email
        expect(page).to have_css "td", text: "Super admin"
      end
      within "#new_filters" do
        select "", from: "Company"
        fill_in "Full name contains", with: "#{employer2.first_name} #{employer2.last_name}"
        click_button "Search"
      end
      within "table tbody" do
        expect(page).to have_css "tr", count: 1
        expect(page).to have_css "td", text: employer2.company.name
        expect(page).to have_css "td", text: employer2.first_name
        expect(page).to have_css "td", text: employer2.last_name
        expect(page).to have_css "td", text: employer2.email
        expect(page).to have_css "td", text: "Super admin"
      end
      within "#new_filters" do
        fill_in "Full name contains", with: ""
        fill_in "Email contains", with: employer1.email
        click_button "Search"
      end
      within "table tbody" do
        expect(page).to have_css "tr", count: 1
        expect(page).to have_css "td", text: employer1.company.name
        expect(page).to have_css "td", text: employer1.first_name
        expect(page).to have_css "td", text: employer1.last_name
        expect(page).to have_css "td", text: employer1.email
        expect(page).to have_css "td", text: "Super admin"
      end
    end

    scenario "I can update an employer" do
      click_link "Employers"
      within "table tbody tr:nth-child(1)" do
        click_link "Edit"
      end
      within "#edit_employer_#{employer2.id}" do
        select "Admin", from: "Role"
        fill_in "First name", with: "SpongeBob"
        fill_in "Last name", with: "SquarePants"
        fill_in "Email", with: "spongebob@example.com"
        expect do
          click_button "Update"
        end.not_to have_enqueued_job(EmailTriggerJob)
      end
      expect(page).to have_css("[role=notice]", text: "Employer was updated successfully.")
      expect(page).not_to have_css("[role=alert]")
      within "table tbody" do
        expect(page).to have_css "tr", count: 2
        within "tr:nth-child(1)" do
          expect(page).to have_css "td", text: employer2.company.name
          expect(page).to have_css "td", text: "SpongeBob"
          expect(page).to have_css "td", text: "SquarePants"
          expect(page).to have_css "td", text: "spongebob@example.com"
          expect(page).to have_css "td", text: "Admin"
        end
        within "tr:nth-child(2)" do
          expect(page).to have_css "td", text: employer1.company.name
          expect(page).to have_css "td", text: employer1.first_name
          expect(page).to have_css "td", text: employer1.last_name
          expect(page).to have_css "td", text: employer1.email
          expect(page).to have_css "td", text: "Super admin"
        end
      end
    end

    scenario "I can't update an employer with errors" do
      click_link "Employers"
      within "table tbody tr:nth-child(1)" do
        click_link "Edit"
      end
      within "#edit_employer_#{employer2.id}" do
        fill_in "First name", with: ""
        fill_in "Last name", with: ""
        fill_in "Email", with: ""
        click_button "Update"
      end
      expect(page).not_to have_css "[role=notice]"
      expect(page).to have_css "[role=alert]", text: "Please review errors and try submitting it again."
      within "#edit_employer_#{employer2.id}" do
        expect_form_errors(
          employer_first_name: "is not present",
          employer_last_name: "is not present",
          employer_email: "is not present",
        )
      end
    end

    scenario "I can delete an employer" do
      click_link "Employers"
      within "table tbody tr:nth-child(1)" do
        click_link "Edit"
      end
      click_link "Delete"
      within "table tbody" do
        expect(page).to have_css "tr", count: 1
        expect(page).to have_css "td", text: employer1.company.name
        expect(page).to have_css "td", text: employer1.first_name
        expect(page).to have_css "td", text: employer1.last_name
        expect(page).to have_css "td", text: employer1.email
        expect(page).to have_css "td", text: "Super admin"
      end
      expect(page).to have_css("[role=notice]", text: "Employer was deleted successfully.")
      expect(page).not_to have_css("[role=alert]")
    end
  end
end
