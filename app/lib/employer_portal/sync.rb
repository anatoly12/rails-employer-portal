module EmployerPortal
  class Sync
    SYNC_DATABASE_URL = ENV["SYNC_DATABASE_URL"]
    SYNC_SECRET_KEY_BASE = ENV["SYNC_SECRET_KEY_BASE"]

    class << self
      def connect
        log("already connected") and return if connected?
        log("SYNC_DATABASE_URL not configured, skip") and return if SYNC_DATABASE_URL.blank?
        @schema = Sequel[schema_name.to_sym]
        ::EmployerPortal::Sync::Views.new(schema).create_or_replace
        ::EmployerPortal::Sync::Legacy.new(schema, self).define_models
        log("connected to #{schema.value}")
      rescue URI::InvalidURIError, Sequel::Error
        abort("Sync: can't connect to #{SYNC_DATABASE_URL}")
      end

      def schema_name
        File.basename URI.parse(SYNC_DATABASE_URL).path
      end

      def connected?
        schema.present?
      end

      def create_account_for_employee!(employee)
        raise ArgumentError, "sync isn't connected" unless connected?
        raise ArgumentError, "SYNC_SECRET_KEY_BASE not configured" unless SYNC_SECRET_KEY_BASE.present?
        ::EmployerPortal::Sync::Employee.new(
          schema,
          SYNC_SECRET_KEY_BASE,
          employee
        ).create_account!
      end

      private

      attr_reader :schema

      def log(message)
        puts "Sync: #{message}"
        true
      end
    end
  end
end
