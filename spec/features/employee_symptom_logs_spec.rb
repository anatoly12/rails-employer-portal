require "rails_helper"

feature "Employee symptom logs" do
  given(:company) { create :company }
  given(:employer) { create :employer, company: company }
  given(:employee) { create :employee, company: company }
  given(:now) { Time.now }
  given(:today) { now.to_date }
  before { sign_in_as_employer employer }

  context "when sync is connected", type: :sync do
    include ActiveSupport::Testing::TimeHelpers
    given(:passport_product) { create :sync_passport_product }
    given(:account) { ::EmployerPortal::Sync::Account[employee.remote_id] }
    given(:user) { ::EmployerPortal::Sync::User[account.user_id] }
    given(:kit) { create :sync_kit, requisition: user.requisitions.first }
    given(:date_type_date) { create :sync_data_type, type_of: "DATE" }
    given(:date_type_text) { create :sync_data_type, type_of: "TEXT" }
    before do
      with_sync_connected
      company.plan.update remote_id: passport_product.pk
      ::EmployerPortal::Sync.create_partner_for_company! company
      ::EmployerPortal::Sync.create_account_for_employee! employee
      travel_to now do
        create :sync_question, kit: kit, question: "How do you feel?", response: "", required: true
        create :sync_question, kit: kit, question: "Are you happy?", response: "", required: false
        create :sync_question, kit: kit, question: "Temperature", response: "99.5ºF", data_type: date_type_text
        create :sync_question, kit: kit, question: "Since when?", response: "2020-06-01", data_type: date_type_date
      end
    end

    context "when employee has no question for the requested date" do
      scenario "I see no entry" do
        visit_symptom_log(today - 1)
        within ".blur-3 .container #entries" do
          expect(page).not_to have_css "li"
        end
      end
    end

    context "when employee has questions for the requested date" do
      scenario "I see some entries" do
        visit_symptom_log today
        within ".blur-3 .container #entries" do
          expect(page).to have_css "> li", count: 3
          within "> li:nth-child(1)" do
            expect(page).to have_css ".rounded-full", text: "1"
            expect(page).to have_css "div", text: "How do you feel?"
            expect(page).to have_css "li", text: "Yes"
            expect(page).to have_css "li", text: "No"
            expect(page).to have_css "li", text: "Don't Know"
          end
          within "> li:nth-child(2)" do
            expect(page).to have_css ".rounded-full", text: "2"
            expect(page).to have_css "div", text: "Temperature"
            expect(page).to have_css "div", text: "99.5ºF"
          end
          within "> li:nth-child(3)" do
            expect(page).to have_css ".rounded-full", text: "3"
            expect(page).to have_css "div", text: "Since when?"
            expect(page).to have_css "div", text: "2020-06-01"
          end
        end
      end
    end
  end

  def visit_symptom_log(date)
    visit "/employees/#{employee.uuid}/symptom_logs/#{date}"
    within ".blur-3 .container" do
      expect(page).to have_css "h2", text: "Symptom log from #{date}"
    end
  end
end
