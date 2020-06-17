# Allow to run rake tasks even if DB is not configured...
table_exists = begin
  Sequel::Model.db.table_exists?(:delayed_jobs)
rescue Sequel::Error, Sequel::DatabaseConnectionError
  false
end
if table_exists
  require "delayed_job_sequel"
  Delayed::Worker.backend = :sequel
  Delayed::Worker.destroy_failed_jobs = false
  Delayed::Worker.sleep_delay = 60
  Delayed::Worker.max_attempts = 3
  Delayed::Worker.max_run_time = 5.minutes
  Delayed::Worker.read_ahead = 10
  Delayed::Worker.default_queue_name = 'default'
  Delayed::Worker.delay_jobs = !Rails.env.test?
  Delayed::Worker.raise_signal_exceptions = :term
  Delayed::Worker.logger = Logger.new(STDOUT)
end
