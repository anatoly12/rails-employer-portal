Rails.application.config.sequel.after_connect = proc do
  if Sequel::Model.db.table_exists?(:delayed_jobs)
    require "delayed_job_sequel"
    Delayed::Worker.backend = :sequel
  end
end
