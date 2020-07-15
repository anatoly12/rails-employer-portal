require "rails_helper"

feature "Dashboard" do
  context "when sync is connected", type: :sync do
    before do
      with_sync_connected
      sign_in_as_admin_user
    end

    scenario "I see more stats" do
      expect(page).to have_css "h2", count: 5
      expect(page).to have_css "h2", text: "Daily Checkup Status"
      expect(page).to have_css "h2", text: "Testing Status"
      expect(page).to have_css "h2", text: "Companies"
      expect(page).to have_css "h2", text: "Users"
      expect(page).to have_css "h2", text: "Email"
    end
  end

  context "when sync is NOT connected" do
    before { sign_in_as_admin_user }

    scenario "I see more stats" do
      expect(page).to have_css "h2", count: 4
      within ".text-red-600" do
        expect(page).to have_css "h2", text: "Sync isn't connected."
      end
      expect(page).to have_css "h2", text: "Companies"
      expect(page).to have_css "h2", text: "Users"
      expect(page).to have_css "h2", text: "Email"
    end
  end
end
