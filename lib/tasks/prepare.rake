task :prepare do
  Rake::Task["db:drop"].invoke rescue nil
  system("rake db:create")
  Rake::Task["db:migrate"].invoke
  Rake::Task["db:test:prepare"].invoke
  storage = SequelRails::Storage.adapter_for(
    "adapter" => "mysql2",
    "database" => "ecp-test",
    "host" => "localhost",
    "port" => 3306,
    "charset" => "utf8",
    "collation" => "utf8_general_ci",
  )
  storage.drop
  storage.create
  storage.load(Rails.root.join("db", "structure-ecp.sql"))
  puts "Load the seed data..."
  Rake::Task["db:seed"].invoke
end
