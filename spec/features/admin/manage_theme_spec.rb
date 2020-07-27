require "rails_helper"

feature "Manage theme" do
  given!(:company) { create :company }
  before { sign_in_as_admin_user }

  scenario "I can update a company theme" do
    click_link "Companies"
    within "table tbody tr:nth-child(1)" do
      click_link "Customize theme"
    end
    within "#edit_theme" do
      expect(page).to have_css "[data-color]", visible: false, count: 36
      expect(page).not_to have_button "Reset"
      page.find("input[name='theme[colors][gradient-top]']", visible: false).set "#ffcc00"
      page.find("input[name='theme[colors][gradient-bottom]']", visible: false).set "#ffff33"
      click_button "Update"
    end
    expect(page).to have_css("[role=notice]", text: "Theme for #{company.name} was updated successfully.")
    expect(page).not_to have_css("[role=alert]")
  end
end
