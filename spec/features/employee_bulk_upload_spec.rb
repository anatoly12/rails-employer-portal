require "rails_helper"

feature "Employee bulk upload" do
  before { sign_in_as_employer }

  scenario "I upload a valid file but the ZIP code doesn't exist" do
    expect do
      upload_file("sample_valid.txt")
    end.not_to have_enqueued_job CreateAccountForEmployeeJob
    expect(page).not_to have_css("[role=notice]")
    expect(page).to have_css("[role=alert]", text: "Error(s) on row 2: zipcode must be a valid ZIP Code.")
  end

  describe "with an existing ZIP code" do
    given!(:zip_code) { create :zip_code, :new_york }

    scenario "I upload a valid file in Unicode text format" do
      expect do
        upload_file("sample_valid.txt")
      end.to have_enqueued_job(CreateAccountForEmployeeJob).exactly(5).times
      expect(page).to have_css("[role=notice]", text: "5 employees were imported successfully.")
      expect(page).not_to have_css("[role=alert]")
    end

    scenario "I upload a valid file in CSV format" do
      expect do
        upload_file("sample_valid.csv")
      end.to have_enqueued_job(CreateAccountForEmployeeJob).exactly(5).times
      expect(page).to have_css("[role=notice]", text: "5 employees were imported successfully.")
      expect(page).not_to have_css("[role=alert]")
    end

    scenario "I upload a valid file in TSV format" do
      expect do
        upload_file("sample_valid.tsv")
      end.to have_enqueued_job(CreateAccountForEmployeeJob).exactly(5).times
      expect(page).to have_css("[role=notice]", text: "5 employees were imported successfully.")
      expect(page).not_to have_css("[role=alert]")
    end

    scenario "I upload a file with an invalid UTF-8 sequence" do
      expect do
        upload_file("sample_invalid.csv")
      end.not_to have_enqueued_job CreateAccountForEmployeeJob
      expect(page).not_to have_css("[role=notice]")
      expect(page).to have_css("[role=alert]", text: "Error: invalid file format.")
    end

    scenario "I upload a file without any employee" do
      expect do
        upload_file("sample_empty.csv")
      end.not_to have_enqueued_job CreateAccountForEmployeeJob
      expect(page).not_to have_css("[role=notice]")
      expect(page).to have_css("[role=alert]", text: "Error: can't find any employee in given file.")
    end
  end

  def upload_file(filename)
    within(".blur-3 .container") do
      click_link "Bulk Upload"
      expect(page).to have_content "Please match your fields to the sample below."
      input = find_field "Upload File"
      input.attach_file(Rails.root.join("spec", "fixtures", filename))
      input.parent_form.submit
    end
  end
end
