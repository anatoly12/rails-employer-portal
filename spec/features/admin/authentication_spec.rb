require "rails_helper"

feature "Admin authentication" do
  given(:admin_user) { create :admin_user }

  scenario "Signing in with correct credentials" do
    visit "/admin"
    within("#new_session") do
      fill_in "Username", with: admin_user.email
      fill_in "Password", with: admin_user.password
      click_button "Sign in"
    end
    expect(page).to have_content "Dashboard"
    expect(page).to have_content "Hi, #{admin_user.email}"
    expect(page).not_to have_selector("[role=notice]")
    expect(page).not_to have_selector("[role=alert]")
  end

  scenario "Trying to sign in with incorrect credentials" do
    visit "/admin"
    within("#new_session") do
      fill_in "Username", with: admin_user.email
      fill_in "Password", with: "wrong password"
      click_button "Sign in"
    end
    expect(page).not_to have_content "Dashboard"
    expect(page).not_to have_content "Hi, #{admin_user.email}"
    expect(page).not_to have_selector("[role=notice]")
    expect(page).to have_selector("[role=alert]", text: "Please review errors and try submitting it again.")
  end
end
