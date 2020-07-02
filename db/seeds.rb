ZipCode.create(
  zip: "10001",
  city: "New York",
  state: "NY",
  geopoint: Sequel.function(:GeomFromText, "POINT(40.750742 -73.99653)"),
)

plan_lite = Plan.create(
  name: "Passport Lite",
  billed_by: "invoice",
  daily_checkup_enabled: true,
  remote_id: 1,
)
Plan.create(
  name: "Passport",
  billed_by: "invoice",
  testing_enabled: true,
  health_passport_enabled: true,
  remote_id: 2,
)
Plan.create(
  name: "Passport Complete",
  billed_by: "invoice",
  daily_checkup_enabled: true,
  testing_enabled: true,
  health_passport_enabled: true,
  remote_id: 3,
)

company = Company.create(
  name: Faker::Company.name,
  plan: plan_lite,
  remote_id: 21,
)

employer = Employer.create(
  company: company,
  first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name,
  email: ENV.fetch("EMPLOYER_EMAIL", Faker::Internet.safe_email),
  password: ENV.fetch("EMPLOYER_PASSWORD", Faker::Internet.password),
  role: "super_admin",
)

admin_user = AdminUser.create(
  email: ENV.fetch("ADMIN_EMAIL", Faker::Internet.safe_email),
  password: ENV.fetch("ADMIN_PASSWORD", Faker::Internet.password),
)

puts
puts "Use \"#{employer.email}\" / \"#{employer.password}\" to sign in as an employer."
puts "Use \"#{admin_user.email}\" / \"#{admin_user.password}\" to sign in as an admin user."
