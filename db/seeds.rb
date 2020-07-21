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
  allowed_to_add_employees: true,
  allowed_to_add_employee_tags: true,
  allowed_all_employee_tags: true,
  allowed_employee_tags: [],
)

admin_user = AdminUser.create(
  email: ENV.fetch("ADMIN_EMAIL", Faker::Internet.safe_email),
  password: ENV.fetch("ADMIN_PASSWORD", Faker::Internet.password),
)

EmailTemplate.create(
  name: "Employee invite",
  subject: "Welcome to Essential Health Passport",
  trigger_key: EmailTemplate::TRIGGER_EMPLOYEE_NEW,
  from: "support@example.com",
  html: "
    <p>Hello {{employee_full_name}}!</p>
    <p>Someone invited you to the Employer Portal. Choose a password through the link below.</p>
    <p><a href='http://localhost:3000/health_modules/password/edit?reset_password_token={{employee_reset_password_token}}'>Choose a password</a></p>
    <p>Thank you and have a nice day.</p>
  ",
)
EmailTemplate.create(
  name: "Employer reset password",
  subject: "Essential Health Employer Portal - Password forgotten",
  trigger_key: EmailTemplate::TRIGGER_EMPLOYEE_NEW,
  from: "support@example.com",
  html: "
    <p>Hello {{employer_first_name}} {{employer_last_name}}!</p>
    <p>Seems like you asked for a new password. Choose a new password through the link below.</p>
    <p><a href='http://employer-portal.test:5000/reset_passwords/{{employer_reset_password_token}}?reset_password[email]={{employer_email}}'>Choose a password</a></p>
    <p>Thank you and have a nice day.</p>
  ",
)

puts
puts "Use \"#{employer.email}\" / \"#{employer.password}\" to sign in as an employer."
puts "Use \"#{admin_user.email}\" / \"#{admin_user.password}\" to sign in as an admin user."
