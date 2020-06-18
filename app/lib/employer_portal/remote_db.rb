module EmployerPortal
  class RemoteDb
    class << self
      attr_reader :db

      def init
        connect
        create_or_replace_views
      end

    private

      def connect
        @db.disconnect if defined? @db
        @db = Sequel.connect ENV["SYNC_DATABASE_URL"]
        Rails.logger.info "Successfully connected to remote DB..."
      rescue Sequel::DatabaseConnectionError
        abort "Can't connect to remote DB, please check that SYNC_DATABASE_URL is correctly configured."
      end

      def create_or_replace_views
        Rails.logger.info "Create or replace views..."
        # TODO
      end
    end
  end
end
