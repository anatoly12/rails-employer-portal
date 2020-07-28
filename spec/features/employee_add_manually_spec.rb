require "rails_helper"

feature "Employee add manually" do
  let(:employer) { create :employer }
  before { sign_in_as_employer employer }

  scenario "I add the first employee" do
    within ".blur-3 .container" do
      click_link "Add New"
    end
    expect(page).to have_content "Register an employee by filling out the form below"
    within "#new_employee" do
      fill_in "First Name", with: "Lashunda"
      fill_in "Last Name", with: "Kohler"
      fill_in "Email", with: "lashunda@example.org"
      fill_in "Phone Number", with: "1-317-415-9130"
      select "New York", from: "State"
      expect do
        click_button "Submit"
      end.to have_enqueued_job(CreateAccountForEmployeeJob).exactly(:once)
    end
    expect(page).to have_css("[role=notice]", text: "Employee was created successfully.")
    expect(page).not_to have_css("[role=alert]")
  end

  scenario "I can't add an employee with errors" do
    within ".blur-3 .container" do
      click_link "Add New"
    end
    expect(page).to have_content "Register an employee by filling out the form below"
    within "#new_employee" do
      expect do
        click_button "Submit"
      end.not_to have_enqueued_job(CreateAccountForEmployeeJob)
    end
    expect(page).not_to have_css("[role=notice]")
    expect(page).to have_css("[role=alert]", text: "Please review errors and try submitting it again.")
    within "form#new_employee" do
      is_expected.to have_form_errors(
        employee_first_name: "is not present",
        employee_last_name: "is not present",
        employee_email: "is not present",
        employee_phone: "is not present",
        employee_state: "is not present",
      )
    end
  end

  context "without javascript" do
    scenario "I add an employee with tags" do
      within ".blur-3 .container" do
        click_link "Add New"
      end
      expect(page).to have_content "Register an employee by filling out the form below"
      within "#new_employee" do
        fill_in "First Name", with: "Lashunda"
        fill_in "Last Name", with: "Kohler"
        fill_in "Email", with: "lashunda@example.org"
        fill_in "Phone Number", with: "1-317-415-9130"
        select "New York", from: "State"
        fill_in "employee_tags", with: "Team A,New York"
        expect do
          click_button "Submit"
        end.to change(Employee, :count).by(1).and change(Audit, :count).by(1)
      end
      employee = Employee.order(:id).last
      audit = Audit.order(:id).last
      expect(employee.tags.map(&:name)).to contain_exactly "Team A", "New York"
      expect(audit.item_type).to eql "Employee"
      expect(audit.item_id).to eql employee.id
      expect(audit.event).to eql "create"
      expect(audit.changes).to eql(
        "company_id" => employer.company_id,
        "employer_id" => employer.id,
        "uuid" => employee.uuid,
        "first_name" => "Lashunda",
        "last_name" => "Kohler",
        "email" => "lashunda@example.org",
        "phone" => "1-317-415-9130",
        "state" => "NY",
        "tags" => "New York,Team A",
      )
    end
  end

  context "with javascript", js: true do
    scenario "I add an employee with tags" do
      within ".blur-3 .container" do
        click_link "Add New"
      end
      expect(page).to have_content "Register an employee by filling out the form below"
      within "#new_employee" do
        fill_in "First Name", with: "Lashunda"
        fill_in "Last Name", with: "Kohler"
        fill_in "Email", with: "lashunda@example.org"
        fill_in "Phone Number", with: "1-317-415-9130"
        select "New York", from: "State"
        page.find("tags [contenteditable]").set "Team A,New York,"
        expect do
          click_button "Submit"
        end.to change(Employee, :count).by(1).and change(Audit, :count).by(1)
      end
      employee = Employee.order(:id).last
      audit = Audit.order(:id).last
      expect(employee.tags.map(&:name)).to contain_exactly "Team A", "New York"
      expect(audit.item_type).to eql "Employee"
      expect(audit.item_id).to eql employee.id
      expect(audit.event).to eql "create"
      expect(audit.changes).to eql(
        "company_id" => employer.company_id,
        "employer_id" => employer.id,
        "uuid" => employee.uuid,
        "first_name" => "Lashunda",
        "last_name" => "Kohler",
        "email" => "lashunda@example.org",
        "phone" => "1-317-415-9130",
        "state" => "NY",
        "tags" => "New York,Team A",
      )
    end
  end
end
