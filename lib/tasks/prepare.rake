# encoding: utf-8
task :prepare do
  Rake::Task["db:drop"].invoke rescue nil
  system("rake db:create")
  Rake::Task["db:migrate"].invoke
  Rake::Task["db:test:prepare"].invoke
  puts "Load the seed data..."
  Rake::Task["db:seed"].invoke
end
