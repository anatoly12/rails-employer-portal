module ApplicationHelpers
  def sign_in_as_employer
    @employer = create :employer, :with_password
    visit "/"
    within("#new_session") do
      fill_in "Email", with: @employer.email
      fill_in "Password", with: @employer.password
      click_button "Sign in"
    end
    expect(page).to have_content "Welcome #{@employer.first_name}!"
  end
end
