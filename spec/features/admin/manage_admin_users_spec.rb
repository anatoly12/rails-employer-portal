require "rails_helper"

feature "Manage admin users" do
  before { sign_in_as_admin_user }

  scenario "I can add a new admin user" do
    click_link "Admin users"
    click_link "Add a new admin user"
    within "#new_admin_user" do
      fill_in "Email", with: Faker::Internet.unique.safe_email
      fill_in "Password", with: Faker::Internet.password
      click_button "Create"
    end
    expect(page).to have_css("[role=notice]", text: "Admin user was created successfully.")
    expect(page).not_to have_css("[role=alert]")
  end

  scenario "I can't add a new admin user with errors" do
    click_link "Admin users"
    click_link "Add a new admin user"
    within "#new_admin_user" do
      click_button "Create"
    end
    expect(page).not_to have_css "[role=notice]"
    expect(page).to have_css "[role=alert]", text: "Please review errors and try submitting it again."
    within "#new_admin_user" do
      is_expected.to have_form_errors(
        admin_user_email: "is not present",
        admin_user_password: "is not present",
      )
    end
  end

  context "with existing admin users" do
    let!(:admin_user1) { create :admin_user }
    let!(:admin_user2) { create :admin_user }

    scenario "I can list admin users (without filters)" do
      click_link "Admin users"
      within "table tbody" do
        expect(page).to have_css "tr", count: 3
        within "tr:nth-child(1)" do
          expect(page).to have_css "td:nth-child(2)", text: admin_user2.email
          expect(page).not_to have_css "td:nth-child(3) svg"
        end
        within "tr:nth-child(2)" do
          expect(page).to have_css "td:nth-child(2)", text: admin_user1.email
          expect(page).not_to have_css "td:nth-child(3) svg"
        end
        within "tr:nth-child(3)" do
          expect(page).to have_css "td:nth-child(2)", text: @admin_user.email
          expect(page).to have_css "td:nth-child(3) svg.text-green-500"
        end
      end
      expect(page).not_to have_link "Filters"
    end

    scenario "I can update an admin user" do
      click_link "Admin users"
      within "table tbody tr:nth-child(1)" do
        click_link "Edit"
      end
      new_email = Faker::Internet.unique.safe_email
      within "#edit_admin_user_#{admin_user2.id}" do
        fill_in "Email", with: new_email
        click_button "Update"
      end
      expect(page).to have_css("[role=notice]", text: "Admin user was updated successfully.")
      expect(page).not_to have_css("[role=alert]")
      within "table tbody" do
        expect(page).to have_css "tr", count: 3
        within "tr:nth-child(1)" do
          expect(page).to have_css "td:nth-child(2)", text: new_email
          expect(page).not_to have_css "td:nth-child(3) svg"
        end
        within "tr:nth-child(2)" do
          expect(page).to have_css "td:nth-child(2)", text: admin_user1.email
          expect(page).not_to have_css "td:nth-child(3) svg"
        end
        within "tr:nth-child(3)" do
          expect(page).to have_css "td:nth-child(2)", text: @admin_user.email
          expect(page).to have_css "td:nth-child(3) svg.text-green-500"
        end
      end
    end

    scenario "I can't update an admin user with errors" do
      click_link "Admin users"
      within "table tbody tr:nth-child(1)" do
        click_link "Edit"
      end
      within "#edit_admin_user_#{admin_user2.id}" do
        fill_in "Email", with: ""
        click_button "Update"
      end
      expect(page).not_to have_css "[role=notice]"
      expect(page).to have_css "[role=alert]", text: "Please review errors and try submitting it again."
      within "#edit_admin_user_#{admin_user2.id}" do
        is_expected.to have_form_errors(
          admin_user_email: "is not present",
        )
      end
    end

    scenario "I can delete an admin user" do
      click_link "Admin users"
      within "table tbody tr:nth-child(1)" do
        click_link "Edit"
      end
      click_link "Delete"
      within "table tbody" do
        expect(page).to have_css "tr", count: 2
        within "tr:nth-child(1)" do
          expect(page).to have_css "td:nth-child(2)", text: admin_user1.email
          expect(page).not_to have_css "td:nth-child(3) svg"
        end
        within "tr:nth-child(2)" do
          expect(page).to have_css "td:nth-child(2)", text: @admin_user.email
          expect(page).to have_css "td:nth-child(3) svg.text-green-500"
        end
      end
      expect(page).to have_css("[role=notice]", text: "Admin user was deleted successfully.")
      expect(page).not_to have_css("[role=alert]")
    end

    scenario "I can't delete myself" do
      click_link "Admin users"
      within "table tbody tr:nth-child(3)" do
        click_link "Edit"
      end
      click_link "Delete"
      within "table tbody" do
        expect(page).to have_css "tr", count: 3
        within "tr:nth-child(1)" do
          expect(page).to have_css "td:nth-child(2)", text: admin_user2.email
          expect(page).not_to have_css "td:nth-child(3) svg"
        end
        within "tr:nth-child(2)" do
          expect(page).to have_css "td:nth-child(2)", text: admin_user1.email
          expect(page).not_to have_css "td:nth-child(3) svg"
        end
        within "tr:nth-child(3)" do
          expect(page).to have_css "td:nth-child(2)", text: @admin_user.email
          expect(page).to have_css "td:nth-child(3) svg.text-green-500"
        end
      end
      expect(page).not_to have_css("[role=notice]")
      expect(page).to have_css("[role=alert]", text: "You can't delete yourself.")
    end
  end
end
