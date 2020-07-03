module AdminHelpers
  def sign_in_as_admin_user
    @admin_user = create :admin_user
    visit "/admin"
    within("#new_session") do
      fill_in "Username", with: @admin_user.email
      fill_in "Password", with: @admin_user.password
      click_button "Sign in"
    end
    expect(page).to have_content "Hi, #{@admin_user.email}"
  end

  def expect_form_errors(errors)
    expect(page).to have_css "p.text-red-400", count: errors.size
    errors.each do |input_id, message|
      expect(page).to have_css "##{input_id} + p.text-red-400", text: message, exact_text: true
    end
  end
end
