module FeatureHelpers
  def sign_in_as_employer(employer = nil)
    employer ||= create :employer
    visit "/"
    within("#new_session") do
      fill_in "Email", with: employer.email
      fill_in "Password", with: employer.password
      click_button "Sign in"
    end
  end

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

  def upload_file(field_name, filename)
    input = find_field field_name
    input.attach_file(Rails.root.join("spec", "fixtures", filename))
    input.parent_form.submit
  end
end
