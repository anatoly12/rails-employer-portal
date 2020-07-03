require "rails_helper"

feature "Manage company" do
  include AdminHelpers
  include SyncHelpers
  given!(:plan) { create :plan }
  before do
    with_sync_connected
    ::EmployerPortal::Sync::Kit.dataset.delete
    ::EmployerPortal::Sync::Partner.dataset.delete
    sign_in_as_admin_user
  end

  context "when sync is connected" do
    let!(:partner) { create :sync_partner }

    scenario "Add a new company" do
      click_link "Companies"
      click_link "Add a new company"
      within("#new_company") do
        fill_in "Name", with: Faker::Company.name
        select plan.name, from: "Plan"
        select partner.name, from: "Linked to partner"
        click_button "Create"
      end
      expect(page).to have_css("[role=notice]", text: "Company was created successfully.")
      expect(page).not_to have_css("[role=alert]")
    end

    scenario "Try to add a new company with errors" do
      click_link "Companies"
      click_link "Add a new company"
      within "#new_company" do
        click_button "Create"
      end
      expect(page).not_to have_css "[role=notice]"
      expect(page).to have_css "[role=alert]", text: "Please review errors and try submitting it again."
      within "#new_company" do
        expect_form_errors(
          company_name: "is not present",
          company_plan_id: "is not present",
          company_remote_id: "is not present",
        )
      end
    end

    context "with existing companies" do
      let(:plan1) { create :plan, name: "Plan 1" }
      let(:plan2) { create :plan, name: "Plan 2" }
      let!(:company1) { create :company, name: "Company 1", plan: plan1 }
      let!(:company2) { create :company, name: "Company 2", plan: plan2 }
      let!(:partner) { create :sync_partner }

      scenario "List and filter companies" do
        click_link "Companies"
        within "table tbody" do
          expect(page).to have_css "tr", count: 2
          within "tr:nth-child(1)" do
            expect(page).to have_css "td", text: "Company 1"
            expect(page).to have_css "td", text: "Plan 1"
          end
          within "tr:nth-child(2)" do
            expect(page).to have_css "td", text: "Company 2"
            expect(page).to have_css "td", text: "Plan 2"
          end
        end
        click_link "Filters"
        within "#new_filters" do
          select "Plan 1", from: "Plan"
          click_button "Search"
        end
        within "table tbody" do
          expect(page).to have_css "tr", count: 1
          expect(page).to have_css "td", text: "Company 1"
          expect(page).to have_css "td", text: "Plan 1"
        end
        within "#new_filters" do
          select "", from: "Plan"
          fill_in "Name contains", with: "Company 2"
          click_button "Search"
        end
        within "table tbody" do
          expect(page).to have_css "tr", count: 1
          expect(page).to have_css "td", text: "Company 2"
          expect(page).to have_css "td", text: "Plan 2"
        end
      end

      scenario "Update a company" do
        click_link "Companies"
        within "table tbody tr:nth-child(1)" do
          click_link "Edit"
        end
        within "#edit_company_#{company1.id}" do
          fill_in "Name", with: "Company A"
          select "Plan 2", from: "Plan"
          select partner.name, from: "Linked to partner"
          click_button "Update"
        end
        expect(page).to have_css("[role=notice]", text: "Company was updated successfully.")
        expect(page).not_to have_css("[role=alert]")
        within "table tbody" do
          expect(page).to have_css "tr", count: 2
          within "tr:nth-child(1)" do
            expect(page).to have_css "td", text: "Company A"
            expect(page).to have_css "td", text: "Plan 2"
          end
          within "tr:nth-child(2)" do
            expect(page).to have_css "td", text: "Company 2"
            expect(page).to have_css "td", text: "Plan 2"
          end
        end
      end

      scenario "Try to update a company with errors" do
        click_link "Companies"
        within "table tbody tr:nth-child(1)" do
          click_link "Edit"
        end
        within "#edit_company_#{company1.id}" do
          fill_in "Name", with: ""
          select "", from: "Plan"
          click_button "Update"
        end
        expect(page).not_to have_css "[role=notice]"
        expect(page).to have_css "[role=alert]", text: "Please review errors and try submitting it again."
        within "#edit_company_#{company1.id}" do
          expect_form_errors(
            company_name: "is not present",
            company_plan_id: "is not present",
            company_remote_id: "is not present",
          )
        end
      end

      scenario "Delete a company" do
        click_link "Companies"
        within "table tbody tr:nth-child(1)" do
          click_link "Edit"
        end
        click_link "Delete"
        within "table tbody" do
          expect(page).to have_css "tr", count: 1
          expect(page).to have_css "td", text: "Company 2"
          expect(page).to have_css "td", text: "Plan 2"
        end
        expect(page).to have_css("[role=notice]", text: "Company was deleted successfully.")
        expect(page).not_to have_css("[role=alert]")
      end
    end
  end
end
