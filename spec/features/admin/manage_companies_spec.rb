require "rails_helper"

feature "Manage companies" do
  given!(:plan) { create :plan }
  before { sign_in_as_admin_user }

  context "when sync is connected", type: :sync do
    let(:partner) { @partner }
    before do
      with_sync_connected
      @partner = create :sync_partner
    end

    scenario "I can add a new company" do
      click_link "Companies"
      click_link "Add a new company"
      within "#new_company" do
        fill_in "Name", with: Faker::Company.name
        select plan.name, from: "Plan"
        select partner.name, from: "Linked to partner", exact: true
        expect(page).not_to have_field "Linked to partner ID", exact: true
        expect {
          click_button "Create"
        }.to have_enqueued_job(CreatePartnerForCompanyJob).exactly(:once)
      end
      expect(page).to have_css("[role=notice]", text: "Company was created successfully.")
      expect(page).not_to have_css("[role=alert]")
    end

    scenario "I can add a new company without partner" do
      click_link "Companies"
      click_link "Add a new company"
      within "#new_company" do
        fill_in "Name", with: Faker::Company.name
        select plan.name, from: "Plan"
        expect {
          click_button "Create"
        }.to have_enqueued_job(CreatePartnerForCompanyJob).exactly(:once)
      end
      expect(page).to have_css("[role=notice]", text: "Company was created successfully.")
      expect(page).not_to have_css("[role=alert]")
    end

    scenario "I can't add a new company with errors" do
      click_link "Companies"
      click_link "Add a new company"
      within "#new_company" do
        expect {
          click_button "Create"
        }.not_to have_enqueued_job CreatePartnerForCompanyJob
      end
      expect(page).not_to have_css "[role=notice]"
      expect(page).to have_css "[role=alert]", text: "Please review errors and try submitting it again."
      within "#new_company" do
        is_expected.to have_form_errors(
          company_name: "is not present",
          company_plan_id: "is not present",
        )
      end
    end

    context "with existing companies" do
      let(:plan1) { create :plan, name: "Plan 1" }
      let(:plan2) { create :plan, name: "Plan 2" }
      let!(:company1) { create :company, name: "Company 1", plan: plan1, remote_id: partner.partner_id }
      let!(:company2) { create :company, name: "Company 2", plan: plan2, remote_id: partner.partner_id }

      scenario "I can list and filter companies" do
        click_link "Companies"
        within "table tbody" do
          expect(page).to have_css "tr", count: 2
          within "tr:nth-child(1)" do
            expect(page).to have_css "td", text: "Company 2"
            expect(page).to have_css "td", text: "Plan 2"
          end
          within "tr:nth-child(2)" do
            expect(page).to have_css "td", text: "Company 1"
            expect(page).to have_css "td", text: "Plan 1"
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

      scenario "I can update a company" do
        click_link "Companies"
        within "table tbody tr:nth-child(1)" do
          click_link "Edit"
        end
        within "#edit_company_#{company2.id}" do
          fill_in "Name", with: "Company B"
          select "Plan 1", from: "Plan"
          click_button "Update"
        end
        expect(page).to have_css("[role=notice]", text: "Company was updated successfully.")
        expect(page).not_to have_css("[role=alert]")
        within "table tbody" do
          expect(page).to have_css "tr", count: 2
          within "tr:nth-child(1)" do
            expect(page).to have_css "td", text: "Company B"
            expect(page).to have_css "td", text: "Plan 1"
          end
          within "tr:nth-child(2)" do
            expect(page).to have_css "td", text: "Company 1"
            expect(page).to have_css "td", text: "Plan 1"
          end
        end
      end

      scenario "I can't update a company with errors" do
        click_link "Companies"
        within "table tbody tr:nth-child(1)" do
          click_link "Edit"
        end
        within "#edit_company_#{company2.id}" do
          fill_in "Name", with: ""
          select "", from: "Plan"
          select "", from: "Linked to partner"
          click_button "Update"
        end
        expect(page).not_to have_css "[role=notice]"
        expect(page).to have_css "[role=alert]", text: "Please review errors and try submitting it again."
        within "#edit_company_#{company2.id}" do
          is_expected.to have_form_errors(
            company_name: "is not present",
            company_plan_id: "is not present",
            company_remote_id: "is not present",
          )
        end
      end

      scenario "I can delete a company" do
        click_link "Companies"
        within "table tbody tr:nth-child(1)" do
          click_link "Edit"
        end
        click_link "Delete"
        within "table tbody" do
          expect(page).to have_css "tr", count: 1
          expect(page).to have_css "td", text: "Company 1"
          expect(page).to have_css "td", text: "Plan 1"
        end
        expect(page).to have_css("[role=notice]", text: "Company was deleted successfully.")
        expect(page).not_to have_css("[role=alert]")
      end
    end
  end

  context "when sync is NOT connected" do
    scenario "I can still add a new company" do
      click_link "Companies"
      click_link "Add a new company"
      within "#new_company" do
        fill_in "Name", with: Faker::Company.name
        select plan.name, from: "Plan"
        fill_in "Linked to partner ID", with: 21, exact: true
        expect(page).not_to have_field "Linked to partner", exact: true
        expect {
          click_button "Create"
        }.to have_enqueued_job(CreatePartnerForCompanyJob).exactly(:once)
      end
      expect(page).to have_css("[role=notice]", text: "Company was created successfully.")
      expect(page).not_to have_css("[role=alert]")
    end

    scenario "I can add a new company without partner" do
      click_link "Companies"
      click_link "Add a new company"
      within "#new_company" do
        fill_in "Name", with: Faker::Company.name
        select plan.name, from: "Plan"
        expect {
          click_button "Create"
        }.to have_enqueued_job(CreatePartnerForCompanyJob).exactly(:once)
      end
      expect(page).to have_css("[role=notice]", text: "Company was created successfully.")
      expect(page).not_to have_css("[role=alert]")
    end
  end
end
