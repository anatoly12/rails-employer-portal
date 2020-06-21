require "rails_helper"

feature "Signing in" do
  given(:password) { Faker::Internet.password }
  given!(:employer) { create :employer, password: password }

  scenario "Signing in with correct credentials" do
    visit "/"
    within("#new_session") do
      fill_in "Email", with: employer.email
      fill_in "Password", with: password
    end
    click_button "Sign in"
    expect(page).to have_content "Welcome #{employer.first_name}!"
  end
end
