require "rails_helper"

feature "Employee bulk upload" do
  before { sign_in_as_employer }

  scenario "I upload a valid file but the ZIP code doesn't exist" do
    within ".blur-3 .container" do
      click_link "Bulk Upload"
      expect(page).to have_content "Please match your fields to the sample below:"
      attach_file "Upload File", Rails.root.join("spec", "fixtures", "sample_valid.txt")
      expect do
        click_button "Submit"
      end.not_to have_enqueued_job CreateAccountForEmployeeJob
    end
    expect(page).not_to have_css("[role=notice]")
    expect(page).to have_css("[role=alert]", text: "Error(s) on row 2: zipcode must be a valid ZIP Code.")
  end

  context "with an existing ZIP code" do
    given!(:zip_code) { create :zip_code, :new_york }

    scenario "I upload a valid file in Unicode text format" do
      within ".blur-3 .container" do
        click_link "Bulk Upload"
        expect(page).to have_content "Please match your fields to the sample below:"
        attach_file "Upload File", Rails.root.join("spec", "fixtures", "sample_valid.txt")
        expect do
          click_button "Submit"
        end.to have_enqueued_job(CreateAccountForEmployeeJob).exactly(5).times
      end
      expect(page).to have_css("[role=notice]", text: "5 employees were imported successfully.")
      expect(page).not_to have_css("[role=alert]")
    end

    scenario "I upload a valid file in CSV format" do
      within ".blur-3 .container" do
        click_link "Bulk Upload"
        expect(page).to have_content "Please match your fields to the sample below:"
        attach_file "Upload File", Rails.root.join("spec", "fixtures", "sample_valid.csv")
        expect do
          click_button "Submit"
        end.to have_enqueued_job(CreateAccountForEmployeeJob).exactly(5).times
      end
      expect(page).to have_css("[role=notice]", text: "5 employees were imported successfully.")
      expect(page).not_to have_css("[role=alert]")
    end

    scenario "I upload a valid file in TSV format" do
      within ".blur-3 .container" do
        click_link "Bulk Upload"
        expect(page).to have_content "Please match your fields to the sample below:"
        attach_file "Upload File", Rails.root.join("spec", "fixtures", "sample_valid.tsv")
        expect do
          click_button "Submit"
        end.to have_enqueued_job(CreateAccountForEmployeeJob).exactly(5).times
      end
      expect(page).to have_css("[role=notice]", text: "5 employees were imported successfully.")
      expect(page).not_to have_css("[role=alert]")
    end

    scenario "I upload a file with an invalid UTF-8 sequence" do
      within ".blur-3 .container" do
        click_link "Bulk Upload"
        expect(page).to have_content "Please match your fields to the sample below:"
        attach_file "Upload File", Rails.root.join("spec", "fixtures", "sample_invalid.csv")
        expect do
          click_button "Submit"
        end.not_to have_enqueued_job CreateAccountForEmployeeJob
      end
      expect(page).not_to have_css("[role=notice]")
      expect(page).to have_css("[role=alert]", text: "Error: invalid file format.")
    end

    scenario "I upload a file without any employee" do
      within ".blur-3 .container" do
        click_link "Bulk Upload"
        expect(page).to have_content "Please match your fields to the sample below:"
        attach_file "Upload File", Rails.root.join("spec", "fixtures", "sample_empty.csv")
        expect do
          click_button "Submit"
        end.not_to have_enqueued_job CreateAccountForEmployeeJob
      end
      expect(page).not_to have_css("[role=notice]")
      expect(page).to have_css("[role=alert]", text: "Error: can't find any employee in given file.")
    end

    context "without javascript" do
      scenario "I can add tags to employees" do
        within ".blur-3 .container" do
          click_link "Bulk Upload"
          fill_in "tags", with: "Team A,New York"
          attach_file "Upload File", Rails.root.join("spec", "fixtures", "sample_valid.txt")
          expect do
            click_button "Submit"
          end.to change(Employee, :count).by(5).and change(Audit, :count).by(1)
        end
        expect(page).to have_css("[role=notice]", text: "5 employees were imported successfully.")
        employees = Employee.order(:id).last(5)
        employees.each do |employee|
          expect(employee.tags.map(&:name)).to contain_exactly "Team A", "New York"
        end
        audit = Audit.order(:id).last
        expect(audit.item_type).to eql "Employee"
        expect(audit.item_id).to be_nil
        expect(audit.event).to eql "import"
        expect(audit.changes).to eql(
          "ids" => employees.map(&:id).sort,
          "tags" => "New York,Team A",
        )
      end

      scenario "tags aren't lost in case of error" do
        within ".blur-3 .container" do
          click_link "Bulk Upload"
          fill_in "tags", with: "Team A,New York"
          attach_file "Upload File", Rails.root.join("spec", "fixtures", "sample_invalid.csv")
          expect do
            click_button "Submit"
          end.to change(Employee, :count).by(0).and change(Audit, :count).by(0)
        end
        expect(page).to have_css("[role=alert]", text: "Error: invalid file format.")
        within ".blur-3 .container" do
          expect(page).to have_field("tags", with: "Team A,New York")
        end
      end
    end

    context "with javascript", js: true do
      scenario "I can add tags to employees" do
        within ".blur-3 .container" do
          click_link "Bulk Upload"
          page.find("tags [contenteditable]").set "Team A,New York,"
          attach_file "Upload File", Rails.root.join("spec", "fixtures", "sample_valid.txt"), visible: false
        end
        expect(page).to have_css("[role=notice]", text: "5 employees were imported successfully.")
        employees = Employee.order(:id).last(5)
        employees.each do |employee|
          expect(employee.tags.map(&:name)).to contain_exactly "Team A", "New York"
        end
        audit = Audit.order(:id).last
        expect(audit.item_type).to eql "Employee"
        expect(audit.item_id).to be_nil
        expect(audit.event).to eql "import"
        expect(audit.changes).to eql(
          "ids" => employees.map(&:id).sort,
          "tags" => "New York,Team A",
        )
      end
    end
  end
end
