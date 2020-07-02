require "rails_helper"

feature "Add employee manually" do
  include ApplicationHelpers

  scenario "Add the first employee" do
    sign_in_as_employer
    within(".blur-3 .container") do
      click_link "Add New"
    end
    expect(page).to have_content "Register an employee by filling out the form below"
    within("#new_employee") do
      fill_in "First Name", with: "Lashunda"
      fill_in "Last Name", with: "Kohler"
      fill_in "Email", with: "lashunda@example.org"
      fill_in "Phone Number", with: "1-317-415-9130"
      select "New York", from: "State"
      expect do
        click_button "Submit"
      end.to have_enqueued_job(CreateAccountForEmployeeJob).exactly(:once)
    end
    expect(page).to have_selector("[role=notice]", text: "Employee was created successfully.")
    expect(page).not_to have_selector("[role=alert]")
  end
end