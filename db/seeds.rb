ZipCode.create(
  zip: "10001",
  city: "New York",
  state: "NY",
  geopoint: Sequel.function(:GeomFromText, "POINT(40.750742 -73.99653)"),
)

company = Company.create(
  name: Faker::Company.name,
  plan: "billed_by_invoice",
  remote_id: 21
)

employer = Employer.create(
  company_id: company.id,
  first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name,
  email: ENV.fetch("EMPLOYER_EMAIL", Faker::Internet.safe_email),
  password: ENV.fetch("EMPLOYER_PASSWORD", Faker::Internet.password),
  role: "super_admin",
)

puts
puts "Use \"#{employer.email}\" / \"#{employer.password}\" to sign in as an employer."
