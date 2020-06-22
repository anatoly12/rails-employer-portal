require "rails_helper"

feature "Authentication" do
  given(:password) { Faker::Internet.password }
  given!(:employer) { create :employer, password: password }

  scenario "Signing in with correct credentials" do
    visit "/"
    within("#new_session") do
      fill_in "Email", with: employer.email
      fill_in "Password", with: password
      click_button "Sign in"
    end
    expect(page).to have_content "Welcome #{employer.first_name}!"
    expect(page).not_to have_selector("[role=notice]")
    expect(page).not_to have_selector("[role=alert]")
  end

  scenario "Trying to sign in with incorrect credentials" do
    visit "/"
    within("#new_session") do
      fill_in "Email", with: employer.email
      fill_in "Password", with: "wrong password"
      click_button "Sign in"
    end
    expect(page).not_to have_content "Welcome #{employer.first_name}!"
    expect(page).not_to have_selector("[role=notice]")
    expect(page).to have_selector("[role=alert]", text: "Please review errors and try submitting it again.")
  end
end
