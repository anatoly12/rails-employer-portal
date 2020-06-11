RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

FactoryBot.define do
  to_create { |instance| instance.save }
end
FactoryBot.find_definitions
