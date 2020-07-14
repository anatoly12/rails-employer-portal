require "rails_helper"

feature "Password forgotten" do
  given!(:employer) { create :employer }

  scenario "I can reset my password" do
    visit "/"
    within("#new_session") do
      click_link "I forgot my password"
    end
    within("#new_reset_password") do
      expect(page).to have_css "h2", text: "Password forgotten"
      fill_in "Email", with: employer.email
      expect do
        click_button "Reset password"
      end.to have_enqueued_job(EmailTriggerJob).with(
        EmailTemplate::TRIGGER_EMPLOYER_PASSWORD_FORGOTTEN,
        employer.uuid,
        hash_including("reset_password_token")
      )
    end
    expect(page).to have_css("[role=notice]", text: "If your email address exists in our database, you should receive a password recovery link soon.")
    expect(page).not_to have_css("[role=alert]")
    expect(page).to have_css("#new_session")
    hash = ActiveJob::Base.queue_adapter.enqueued_jobs.last[:args].last
    expect(::BCrypt::Password.new(employer.reload.reset_password_digest) == hash["reset_password_token"]).to be true
    visit "/reset_passwords/#{hash["reset_password_token"]}?reset_password[email]=#{employer.email}"
    new_password = Faker::Internet.password
    within("#new_reset_password") do
      expect(page).to have_css "h2", text: "Choose a new password"
      fill_in "Password", with: new_password
      click_button "Update password"
    end
    expect(page).to have_content "Welcome #{employer.first_name}!"
    expect(page).to have_css("[role=notice]", text: "Your password was updated successfully.")
    expect(page).not_to have_css("[role=alert]")
    visit "/reset_passwords/#{hash["reset_password_token"]}?reset_password[email]=#{employer.email}"
    expect(page).not_to have_css("[role=notice]")
    expect(page).to have_css("[role=alert]", text: "Your reset password token is invalid or expired. Please try again.")
  end

  scenario "I can't trigger an email if I'm not in the system" do
    visit "/"
    within("#new_session") do
      click_link "I forgot my password"
    end
    wrong_email = Faker::Internet.unique.safe_email
    within("#new_reset_password") do
      expect(page).to have_css "h2", text: "Password forgotten"
      fill_in "Email", with: wrong_email
      expect do
        click_button "Reset password"
      end.not_to have_enqueued_job(EmailTriggerJob)
    end
    expect(page).to have_css("[role=notice]", text: "If your email address exists in our database, you should receive a password recovery link soon.")
    expect(page).not_to have_css("[role=alert]")
    expect(page).to have_css("#new_session")
  end

  scenario "I can't trigger an email with errors" do
    visit "/"
    within("#new_session") do
      click_link "I forgot my password"
    end
    within("#new_reset_password") do
      expect(page).to have_css "h2", text: "Password forgotten"
      expect do
        click_button "Reset password"
      end.not_to have_enqueued_job(EmailTriggerJob)
    end
    expect(page).not_to have_css("[role=notice]")
    expect(page).to have_css("[role=alert]", text: "Please review errors and try submitting it again.")
    within("#new_reset_password") do
      is_expected.to have_form_errors(
        reset_password_email: "can't be blank",
      )
      expect(page).to have_css "h2", text: "Password forgotten"
      fill_in "Email", with: "a@"
      expect do
        click_button "Reset password"
      end.not_to have_enqueued_job(EmailTriggerJob)
    end
    expect(page).not_to have_css("[role=notice]")
    expect(page).to have_css("[role=alert]", text: "Please review errors and try submitting it again.")
    within("#new_reset_password") do
      is_expected.to have_form_errors(
        reset_password_email: "is invalid",
      )
    end
  end
end
