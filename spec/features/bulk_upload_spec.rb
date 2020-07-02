require "rails_helper"

feature "Bulk upload" do
  include ApplicationHelpers

  def upload_file(filename)
    sign_in_as_employer
    within(".blur-3 .container") do
      click_link "Bulk Upload"
      expect(page).to have_content "Please match your fields to the sample below."
      input = find_field "Upload File"
      input.attach_file(Rails.root.join("spec", "fixtures", filename))
      input.parent_form.submit
    end
  end

  scenario "Upload a valid file in Unicode text format" do
    create :zip_code, :new_york

    expect do
      upload_file("sample_valid.txt")
    end.to have_enqueued_job(CreateAccountForEmployeeJob).exactly(5).times
    expect(page).to have_selector("[role=notice]", text: "5 employees were imported successfully.")
    expect(page).not_to have_selector("[role=alert]")
  end

  scenario "Upload a valid file in CSV format" do
    create :zip_code, :new_york
    expect do
      upload_file("sample_valid.csv")
    end.to have_enqueued_job(CreateAccountForEmployeeJob).exactly(5).times
    expect(page).to have_selector("[role=notice]", text: "5 employees were imported successfully.")
    expect(page).not_to have_selector("[role=alert]")
  end

  scenario "Upload a valid file in TSV format" do
    create :zip_code, :new_york
    expect do
      upload_file("sample_valid.tsv")
    end.to have_enqueued_job(CreateAccountForEmployeeJob).exactly(5).times
    expect(page).to have_selector("[role=notice]", text: "5 employees were imported successfully.")
    expect(page).not_to have_selector("[role=alert]")
  end

  scenario "Upload valid file but ZIP code doesn't exist" do
    expect do
      upload_file("sample_valid.txt")
    end.not_to have_enqueued_job CreateAccountForEmployeeJob
    expect(page).not_to have_selector("[role=notice]")
    expect(page).to have_selector("[role=alert]", text: "Error(s) on row 2: zipcode must be a valid ZIP Code.")
  end

  scenario "Upload a file with invalid UTF-8 sequence" do
    create :zip_code, :new_york
    expect do
      upload_file("sample_invalid.csv")
    end.not_to have_enqueued_job CreateAccountForEmployeeJob
    expect(page).not_to have_selector("[role=notice]")
    expect(page).to have_selector("[role=alert]", text: "Error: invalid file format.")
  end

  scenario "Upload a file without any employee" do
    create :zip_code, :new_york
    expect do
      upload_file("sample_empty.csv")
    end.not_to have_enqueued_job CreateAccountForEmployeeJob
    expect(page).not_to have_selector("[role=notice]")
    expect(page).to have_selector("[role=alert]", text: "Error: can't find any employee in given file.")
  end
end
