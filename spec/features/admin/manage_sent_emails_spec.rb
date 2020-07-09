require "rails_helper"

feature "Manage sent emails" do
  include AdminHelpers

  let!(:email_log1) { create :email_log, created_at: Time.utc(2020, 6, 2, 10) }
  let!(:email_log2) { create :email_log, trigger_key: EmailTemplate::TRIGGER_EMPLOYER_NEW, created_at: Time.utc(2020, 6, 3, 10) }
  before { sign_in_as_admin_user }

  scenario "I can list and filter email logs" do
    click_link "Sent emails"
    within "table tbody" do
      expect(page).to have_css "tr", count: 2
      within "tr:nth-child(1)" do
        expect(page).to have_css "td:nth-child(1)", text: "2020-06-03 10:00 UTC"
        expect(page).to have_css "td:nth-child(2)", text: email_log2.company.name
        expect(page).to have_css "td:nth-child(3)", text: "Employer new"
        expect(page).to have_css "td:nth-child(4)", text: email_log2.recipient
      end
      within "tr:nth-child(2)" do
        expect(page).to have_css "td:nth-child(1)", text: "2020-06-02 10:00 UTC"
        expect(page).to have_css "td:nth-child(2)", text: email_log1.company.name
        expect(page).to have_css "td:nth-child(3)", text: "Employee new"
        expect(page).to have_css "td:nth-child(4)", text: email_log1.recipient
      end
    end
    click_link "Filters"
    within "#new_filters" do
      select email_log1.company.name, from: "Company"
      click_button "Search"
    end
    within "table tbody" do
      expect(page).to have_css "tr", count: 1
      expect(page).to have_css "td:nth-child(1)", text: "2020-06-02 10:00 UTC"
      expect(page).to have_css "td:nth-child(2)", text: email_log1.company.name
      expect(page).to have_css "td:nth-child(3)", text: "Employee new"
      expect(page).to have_css "td:nth-child(4)", text: email_log1.recipient
    end
    within "#new_filters" do
      select "", from: "Company"
      select "Admin user invites a new employer", from: "Trigger"
      click_button "Search"
    end
    within "table tbody" do
      expect(page).to have_css "tr", count: 1
      expect(page).to have_css "td:nth-child(1)", text: "2020-06-03 10:00 UTC"
      expect(page).to have_css "td:nth-child(2)", text: email_log2.company.name
      expect(page).to have_css "td:nth-child(3)", text: "Employer new"
      expect(page).to have_css "td:nth-child(4)", text: email_log2.recipient
    end
    within "#new_filters" do
      select "", from: "Trigger"
      fill_in "Recipient contains", with: email_log1.recipient
      click_button "Search"
    end
    within "table tbody" do
      expect(page).to have_css "tr", count: 1
      expect(page).to have_css "td:nth-child(1)", text: "2020-06-02 10:00 UTC"
      expect(page).to have_css "td:nth-child(2)", text: email_log1.company.name
      expect(page).to have_css "td:nth-child(3)", text: "Employee new"
      expect(page).to have_css "td:nth-child(4)", text: email_log1.recipient
    end
    within "#new_filters" do
      fill_in "Recipient contains", with: ""
      fill_in "Sent at ≥", with: "2020-06-03"
      click_button "Search"
    end
    within "table tbody" do
      expect(page).to have_css "tr", count: 1
      expect(page).to have_css "td:nth-child(1)", text: "2020-06-03 10:00 UTC"
      expect(page).to have_css "td:nth-child(2)", text: email_log2.company.name
      expect(page).to have_css "td:nth-child(3)", text: "Employer new"
      expect(page).to have_css "td:nth-child(4)", text: email_log2.recipient
    end
    within "#new_filters" do
      fill_in "Sent at ≥", with: ""
      fill_in "Sent at ≤", with: "2020-06-02"
      click_button "Search"
    end
    within "table tbody" do
      expect(page).to have_css "tr", count: 1
      expect(page).to have_css "td:nth-child(1)", text: "2020-06-02 10:00 UTC"
      expect(page).to have_css "td:nth-child(2)", text: email_log1.company.name
      expect(page).to have_css "td:nth-child(3)", text: "Employee new"
      expect(page).to have_css "td:nth-child(4)", text: email_log1.recipient
    end
  end

  scenario "I can view an email log details" do
    click_link "Sent emails"
    within "table tbody tr:nth-child(1)" do
      click_link "Details"
    end
    expect(page).to have_css "#email_log_sent_at", text: "2020-06-03 10:00 UTC"
    expect(page).to have_css "#email_log_from", text: email_log2.from
    expect(page).to have_css "#email_log_recipient", text: email_log2.recipient
    expect(page).to have_css "#email_log_subject", text: email_log2.subject
    iframe = page.find_by_id "email_log_html"
    expect(iframe[:srcdoc]).to eql email_log2.html
    expect(page).to have_css "#email_log_text", text: email_log2.text
  end
end
