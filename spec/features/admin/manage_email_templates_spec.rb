require "rails_helper"

feature "Manage email templates" do
  given!(:plan) { create :plan }
  before { sign_in_as_admin_user }

  context "when sync is connected", type: :sync do
    let(:message_code) { @message_code }
    before do
      with_sync_connected
      @message_code = create :sync_covid19_message_code
    end

    scenario "I can add a new email template", js: true do
      click_link "Email templates"
      click_link "Add a new email template"
      within "#new_email_template" do
        fill_in "Name (admin only)", with: "Template 1"
        fill_in "Subject", with: "Welcome to Essential Health Passport"
        expect(page).not_to have_field "App notification"
        select "Employer invites a new employee", from: "Trigger"
        fill_in "From", with: "support@example.org"
        select message_code.message_subject, from: "App notification", exact: true
        expect(page).not_to have_field "App notification ID", exact: true
        click_button "Create"
      end
      expect(page).to have_css("[role=notice]", text: "Email template was created successfully.")
      expect(page).not_to have_css("[role=alert]")
    end

    scenario "I can add a new email template without app notification" do
      click_link "Email templates"
      click_link "Add a new email template"
      within "#new_email_template" do
        fill_in "Name (admin only)", with: "Template 1"
        fill_in "Subject", with: "Welcome to Essential Health Passport"
        select "Employer invites a new employee", from: "Trigger"
        fill_in "From", with: "support@example.org"
        click_button "Create"
      end
      expect(page).to have_css("[role=notice]", text: "Email template was created successfully.")
      expect(page).not_to have_css("[role=alert]")
    end

    scenario "I can't add a new email template with errors" do
      click_link "Email templates"
      click_link "Add a new email template"
      within "#new_email_template" do
        click_button "Create"
      end
      expect(page).not_to have_css "[role=notice]"
      expect(page).to have_css "[role=alert]", text: "Please review errors and try submitting it again."
      within "#new_email_template" do
        is_expected.to have_form_errors(
          email_template_name: "is not present",
          email_template_subject: "is not present",
          email_template_trigger_key: "is not present",
          email_template_from: "is not present",
        )
      end
    end

    context "with existing email templates" do
      let(:plan1) { create :plan, name: "Plan 1" }
      let(:plan2) { create :plan, name: "Plan 2" }
      let!(:email_template1) { create :email_template, name: "Template 1", plan: plan1 }
      let!(:email_template2) { create :email_template, name: "Template 2", plan: plan2 }

      scenario "I can list and filter email templates" do
        click_link "Email templates"
        within "table tbody" do
          expect(page).to have_css "tr", count: 2
          within "tr:nth-child(1)" do
            expect(page).to have_css "td:nth-child(2)", text: "Template 2"
            expect(page).to have_css "td:nth-child(3)", text: "Employee new"
            expect(page).to have_css "td:nth-child(4)", text: "Plan 2"
          end
          within "tr:nth-child(2)" do
            expect(page).to have_css "td:nth-child(2)", text: "Template 1"
            expect(page).to have_css "td:nth-child(3)", text: "Employee new"
            expect(page).to have_css "td:nth-child(4)", text: "Plan 1"
          end
        end
        click_link "Filters"
        within "#new_filters" do
          select "Plan 1", from: "Plan"
          click_button "Search"
        end
        within "table tbody" do
          expect(page).to have_css "tr", count: 1
          expect(page).to have_css "td:nth-child(2)", text: "Template 1"
          expect(page).to have_css "td:nth-child(3)", text: "Employee new"
          expect(page).to have_css "td:nth-child(4)", text: "Plan 1"
        end
        within "#new_filters" do
          select "", from: "Plan"
          fill_in "Name contains", with: "Template 2"
          click_button "Search"
        end
        within "table tbody" do
          expect(page).to have_css "tr", count: 1
          expect(page).to have_css "td:nth-child(2)", text: "Template 2"
          expect(page).to have_css "td:nth-child(3)", text: "Employee new"
          expect(page).to have_css "td:nth-child(4)", text: "Plan 2"
        end
      end

      scenario "I can update an email template" do
        click_link "Email templates"
        within "table tbody tr:nth-child(1)" do
          click_link "Edit"
        end
        within "#edit_email_template_#{email_template2.id}" do
          fill_in "Name", with: "Template B"
          select "Admin user invites a new employer", from: "Trigger"
          select "Plan 1", from: "Company plan"
          click_button "Update"
        end
        expect(page).to have_css("[role=notice]", text: "Email template was updated successfully.")
        expect(page).not_to have_css("[role=alert]")
        within "table tbody" do
          expect(page).to have_css "tr", count: 2
          within "tr:nth-child(1)" do
            expect(page).to have_css "td:nth-child(2)", text: "Template B"
            expect(page).to have_css "td:nth-child(3)", text: "Employer new"
            expect(page).to have_css "td:nth-child(4)", text: "Plan 1"
          end
          within "tr:nth-child(2)" do
            expect(page).to have_css "td:nth-child(2)", text: "Template 1"
            expect(page).to have_css "td:nth-child(3)", text: "Employee new"
            expect(page).to have_css "td:nth-child(4)", text: "Plan 1"
          end
        end
      end

      scenario "I can't update an email template with errors" do
        click_link "Email templates"
        within "table tbody tr:nth-child(1)" do
          click_link "Edit"
        end
        within "#edit_email_template_#{email_template2.id}" do
          fill_in "Name (admin only)", with: ""
          fill_in "Subject", with: ""
          select "", from: "Trigger"
          fill_in "From", with: ""
          click_button "Update"
        end
        expect(page).not_to have_css "[role=notice]"
        expect(page).to have_css "[role=alert]", text: "Please review errors and try submitting it again."
        within "#edit_email_template_#{email_template2.id}" do
          is_expected.to have_form_errors(
            email_template_name: "is not present",
            email_template_subject: "is not present",
            email_template_trigger_key: "is not present",
            email_template_from: "is not present",
          )
        end
      end

      scenario "I can delete an email template" do
        click_link "Email templates"
        within "table tbody tr:nth-child(1)" do
          click_link "Edit"
        end
        click_link "Delete"
        within "table tbody" do
          expect(page).to have_css "tr", count: 1
          expect(page).to have_css "td:nth-child(2)", text: "Template 1"
          expect(page).to have_css "td:nth-child(3)", text: "Employee new"
          expect(page).to have_css "td:nth-child(4)", text: "Plan 1"
        end
        expect(page).to have_css("[role=notice]", text: "Email template was deleted successfully.")
        expect(page).not_to have_css("[role=alert]")
      end
    end
  end

  context "when sync is NOT connected" do
    scenario "I can still add a new email template", js: true do
      click_link "Email templates"
      click_link "Add a new email template"
      within "#new_email_template" do
        fill_in "Name (admin only)", with: "Template 1"
        fill_in "Subject", with: "Welcome to Essential Health Passport"
        expect(page).not_to have_field "App notification"
        select "Employer invites a new employee", from: "Trigger"
        fill_in "From", with: "support@example.org"
        fill_in "App notification ID", with: 1, exact: true
        expect(page).not_to have_field "App notification", exact: true
        click_button "Create"
      end
      expect(page).to have_css("[role=notice]", text: "Email template was created successfully.")
      expect(page).not_to have_css("[role=alert]")
    end

    scenario "I can add a new email template without app notification" do
      click_link "Email templates"
      click_link "Add a new email template"
      within "#new_email_template" do
        fill_in "Name (admin only)", with: "Template 1"
        fill_in "Subject", with: "Welcome to Essential Health Passport"
        select "Employer invites a new employee", from: "Trigger"
        fill_in "From", with: "support@example.org"
        click_button "Create"
      end
      expect(page).to have_css("[role=notice]", text: "Email template was created successfully.")
      expect(page).not_to have_css("[role=alert]")
    end
  end
end
