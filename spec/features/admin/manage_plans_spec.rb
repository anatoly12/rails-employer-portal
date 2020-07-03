require "rails_helper"

feature "Manage plans" do
  include AdminHelpers
  include SyncHelpers

  context "when sync is connected" do
    let(:passport_product) { @passport_product }
    before do
      with_sync_connected
      @passport_product = create :sync_passport_product
      sign_in_as_admin_user
    end

    scenario "I can add a new plan" do
      click_link "Plans"
      click_link "Add a new plan"
      within("#new_plan") do
        fill_in "Name", with: Faker::Commerce.product_name
        fill_in "Employer limit", with: "0"
        fill_in "Employee limit", with: "0"
        select passport_product.name, from: "Linked to passport product", exact: true
        expect(page).not_to have_field "Linked to passport product ID", exact: true
        click_button "Create"
      end
      expect(page).to have_css("[role=notice]", text: "Plan was created successfully.")
      expect(page).not_to have_css("[role=alert]")
    end

    scenario "I can't add a new plan with errors" do
      click_link "Plans"
      click_link "Add a new plan"
      within "#new_plan" do
        click_button "Create"
      end
      expect(page).not_to have_css "[role=notice]"
      expect(page).to have_css "[role=alert]", text: "Please review errors and try submitting it again."
      within "#new_plan" do
        expect_form_errors(
          plan_name: "is not present",
          plan_employer_limit: "is not a number",
          plan_employee_limit: "is not a number",
        )
      end
    end

    context "with existing plans" do
      let!(:plan1) { create :plan, name: "Plan 1", testing_enabled: false, health_passport_enabled: false }
      let!(:plan2) { create :plan, name: "Plan 2", daily_checkup_enabled: false }

      scenario "I can list plans (without filters)" do
        click_link "Plans"
        within "table tbody" do
          expect(page).to have_css "tr", count: 2
          within "tr:nth-child(1)" do
            expect(page).to have_css "td", text: "Plan 2"
            expect(page).to have_css "td:nth-child(3) svg.text-red-500"
            expect(page).to have_css "td:nth-child(4) svg.text-green-500"
            expect(page).to have_css "td:nth-child(5) svg.text-green-500"
            expect(page).to have_css "td:nth-child(6)", text: "Unlimited"
            expect(page).to have_css "td:nth-child(7)", text: "Unlimited"
          end
          within "tr:nth-child(2)" do
            expect(page).to have_css "td", text: "Plan 1"
            expect(page).to have_css "td:nth-child(3) svg.text-green-500"
            expect(page).to have_css "td:nth-child(4) svg.text-red-500"
            expect(page).to have_css "td:nth-child(5) svg.text-red-500"
            expect(page).to have_css "td:nth-child(6)", text: "Unlimited"
            expect(page).to have_css "td:nth-child(7)", text: "Unlimited"
          end
        end
        expect(page).not_to have_link "Filters"
      end

      scenario "I can update a plan" do
        click_link "Plans"
        within "table tbody tr:nth-child(1)" do
          click_link "Edit"
        end
        within "#edit_plan_#{plan2.id}" do
          fill_in "Name", with: "Plan B"
          check "Daily checkup enabled"
          fill_in "Employer limit", with: "5"
          fill_in "Employee limit", with: "200"
          click_button "Update"
        end
        expect(page).to have_css("[role=notice]", text: "Plan was updated successfully.")
        expect(page).not_to have_css("[role=alert]")
        within "table tbody" do
          expect(page).to have_css "tr", count: 2
          within "tr:nth-child(1)" do
            expect(page).to have_css "td", text: "Plan B"
            expect(page).to have_css "td:nth-child(3) svg.text-green-500"
            expect(page).to have_css "td:nth-child(4) svg.text-green-500"
            expect(page).to have_css "td:nth-child(5) svg.text-green-500"
            expect(page).to have_css "td:nth-child(6)", text: "5"
            expect(page).to have_css "td:nth-child(7)", text: "200"
          end
          within "tr:nth-child(2)" do
            expect(page).to have_css "td", text: "Plan 1"
            expect(page).to have_css "td:nth-child(3) svg.text-green-500"
            expect(page).to have_css "td:nth-child(4) svg.text-red-500"
            expect(page).to have_css "td:nth-child(5) svg.text-red-500"
            expect(page).to have_css "td:nth-child(6)", text: "Unlimited"
            expect(page).to have_css "td:nth-child(7)", text: "Unlimited"
          end
        end
      end

      scenario "I can't update a plan with errors" do
        click_link "Plans"
        within "table tbody tr:nth-child(1)" do
          click_link "Edit"
        end
        within "#edit_plan_#{plan2.id}" do
          fill_in "Name", with: ""
          uncheck "Testing enabled"
          fill_in "Employer limit", with: ""
          fill_in "Employee limit", with: ""
          click_button "Update"
        end
        expect(page).not_to have_css "[role=notice]"
        expect(page).to have_css "[role=alert]", text: "Please review errors and try submitting it again."
        within "#edit_plan_#{plan2.id}" do
          expect_form_errors(
            plan_name: "is not present",
            plan_health_passport_enabled: "requires testing to be enabled",
            plan_employer_limit: "is not a number",
            plan_employee_limit: "is not a number",
          )
        end
      end

      scenario "I can delete a plan" do
        click_link "Plans"
        within "table tbody tr:nth-child(1)" do
          click_link "Edit"
        end
        click_link "Delete"
        within "table tbody" do
          expect(page).to have_css "tr", count: 1
          expect(page).to have_css "td", text: "Plan 1"
          expect(page).to have_css "td:nth-child(3) svg.text-green-500"
          expect(page).to have_css "td:nth-child(4) svg.text-red-500"
          expect(page).to have_css "td:nth-child(5) svg.text-red-500"
          expect(page).to have_css "td:nth-child(6)", text: "Unlimited"
          expect(page).to have_css "td:nth-child(7)", text: "Unlimited"
        end
        expect(page).to have_css("[role=notice]", text: "Plan was deleted successfully.")
        expect(page).not_to have_css("[role=alert]")
      end
    end
  end

  context "when sync is NOT connected" do
    before { sign_in_as_admin_user }

    scenario "I can still add a new plan" do
      click_link "Plans"
      click_link "Add a new plan"
      within("#new_plan") do
        fill_in "Name", with: Faker::Commerce.product_name
        fill_in "Employer limit", with: "0"
        fill_in "Employee limit", with: "0"
        fill_in "Linked to passport product ID", with: 21, exact: true
        expect(page).not_to have_field "Linked to passport product", exact: true
        click_button "Create"
      end
      expect(page).to have_css("[role=notice]", text: "Plan was created successfully.")
      expect(page).not_to have_css("[role=alert]")
    end

    scenario "I can also add a new plan without passport product" do
      click_link "Plans"
      click_link "Add a new plan"
      within("#new_plan") do
        fill_in "Name", with: Faker::Commerce.product_name
        fill_in "Employer limit", with: "0"
        fill_in "Employee limit", with: "0"
        click_button "Create"
      end
      expect(page).to have_css("[role=notice]", text: "Plan was created successfully.")
      expect(page).not_to have_css("[role=alert]")
    end
  end
end
