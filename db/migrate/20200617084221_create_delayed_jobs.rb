# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :delayed_jobs do
      primary_key :id, serial: true
      Integer :priority, default: 0
      Integer :attempts, default: 0
      String :handler, text: true
      String :last_error, text: true
      Time :run_at
      Time :locked_at
      Time :failed_at
      String :locked_by
      String :queue
      Time :created_at
      Time :updated_at
      index [:priority, :run_at]
      # TODO: if we switch to PostgreSQL which supports partial indexes
      # we can try something like this instead:
      # index   [:locked_by, :locked_at], where: {failed_at: nil}
      index :failed_at
    end
  end
end
