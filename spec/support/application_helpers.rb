module ApplicationHelpers
  def sign_in_as_employer(employer = nil)
    employer ||= create :employer
    visit "/"
    within("#new_session") do
      fill_in "Email", with: employer.email
      fill_in "Password", with: employer.password
      click_button "Sign in"
    end
  end
end
