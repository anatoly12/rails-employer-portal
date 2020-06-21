require "rails_helper"

describe "the signin process", type: :feature, js: true do
  let(:password) { Faker::Internet.password }
  let!(:employer) { create :employer, password: password }

  it "signs me in" do
    visit "/"
    within("#new_session") do
      fill_in "Email", with: employer.email
      fill_in "Password", with: password
    end
    click_button "Sign in"
    expect(page).to have_content "Welcome #{employer.first_name}!"
  end
end
