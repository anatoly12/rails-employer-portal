first_name = Faker::Name.first_name
user = User.create(
  first_name: first_name,
  last_name: Faker::Name.last_name,
  email: ENV.fetch("EMPLOYER_EMAIL", Faker::Internet.safe_email(name: first_name)),
  password: ENV.fetch("EMPLOYER_PASSWORD", Faker::Internet.password)
)

puts
puts "Use \"#{user.email}\" / \"#{user.password}\" to sign in as an employer."
