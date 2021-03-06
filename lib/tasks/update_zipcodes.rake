require "open-uri"
require "csv"

task update_zipcodes: :environment do
  filename = Rails.root.join("tmp", "zipcodes.txt")
  if filename.exist?
    puts "Existing dataset found..."
  else
    puts "Fetch latest dataset..."
    download = URI.open("https://public.opendatasoft.com/explore/dataset/us-zip-code-latitude-and-longitude/download/?format=csv&lang=en&use_labels_for_header=true&csv_separator=%3B")
    IO.copy_stream(download, filename)
  end
  puts "Truncate zip_codes table..."
  ZipCode.dataset.truncate
  puts "Read CSV and zip codes..."
  keys = [:zip, :city, :state, :geopoint]
  values = []
  CSV.read(filename, col_sep: ";", headers: true).each do |row|
    values << [
      row["Zip"],
      row["City"],
      row["State"],
      Sequel.function(:GeomFromText, "POINT(#{row["Latitude"]} #{row["Longitude"]})"),
    ]
  end
  ZipCode.import keys, values
  puts "Done."
end
