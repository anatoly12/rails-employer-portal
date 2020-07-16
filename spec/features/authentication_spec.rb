require "rails_helper"

feature "Authentication" do
  given(:employer) { create :employer }

  scenario "I sign in with the correct credentials" do
    visit "/"
    within "#new_session" do
      expect(page).to have_css "h2", text: "Sign into your account"
      fill_in "Email", with: employer.email
      fill_in "Password", with: employer.password
      click_button "Sign in"
    end
    expect(page).to have_content "Welcome #{employer.first_name}!"
    expect(page).not_to have_css("[role=notice]")
    expect(page).not_to have_css("[role=alert]")
  end

  scenario "I try to sign in with the wrong credentials" do
    visit "/"
    within "#new_session" do
      expect(page).to have_css "h2", text: "Sign into your account"
      fill_in "Email", with: employer.email
      fill_in "Password", with: "wrong password"
      click_button "Sign in"
    end
    expect(page).not_to have_content "Welcome #{employer.first_name}!"
    expect(page).not_to have_css("[role=notice]")
    expect(page).to have_css("[role=alert]", text: "Please review errors and try submitting it again.")
  end
end
