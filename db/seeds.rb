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
  employer_limit: 0,
  employee_limit: 0,
  remote_id: 1,
)
Plan.create(
  name: "Passport",
  billed_by: "invoice",
  testing_enabled: true,
  health_passport_enabled: true,
  employer_limit: 0,
  employee_limit: 0,
  remote_id: 2,
)
Plan.create(
  name: "Passport Complete",
  billed_by: "invoice",
  daily_checkup_enabled: true,
  testing_enabled: true,
  health_passport_enabled: true,
  employer_limit: 0,
  employee_limit: 0,
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

EmailTemplate.create(
  name: "Employee new",
  subject: "Welcome to Essential Health Passport",
  trigger_key: "employee_new",
  from: "support@example.com",
  html: "
    <p>Hello {{employee_email}}!</p>
    <p>Someone invited you to the Employer Portal. Choose an email through the link below.</p>
    <p><a href='http://localhost:3000/changepw?reset_password_token={{employee_reset_password_token}}'>Choose a password</a></p>
    <p>Thank you and have a nice day.</p>
  ",
  text: "
    Hello {{employee_email}}!

    Someone invited you to the Employer Portal. Choose an email through the link below:

    http://localhost:3000/changepw?reset_password_token={{employee_reset_password_token}}

    Thank you and have a nice day.
  "
)

puts
puts "Use \"#{employer.email}\" / \"#{employer.password}\" to sign in as an employer."
puts "Use \"#{admin_user.email}\" / \"#{admin_user.password}\" to sign in as an admin user."
