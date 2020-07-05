module EmployerPortal
  module Sync
    class Company
      # ~~ constants ~~
      ALPHANUMS = %w(A B C D E F G H J K L M N P Q R S T U V W X Y Z 2 3 4 5 6 7 8 9)

      # ~~ public instance methods ~~
      def initialize(schema, company, now = Time.now)
        @schema = schema
        @company = company
        @now = now
      end

      def create_partner!
        db.transaction do
          partner = create_partner
          create_access_code(partner)
          company.update remote_id: partner.partner_id, remote_sync_at: now
        end
      rescue Sequel::Error => e
        raise ::EmployerPortal::Error::Sync::CantCreatePartner, e.message
      end

      private

      attr_reader :schema, :company, :now

      # ~~ private instance methods ~~
      def db
        Sequel::Model.db
      end

      def create_partner
        Partner.create(
          name: company.name,
          type_of: "CONSUMER",
          passport_product_id: company.plan.remote_id,
        )
      end

      def new_access_code
        @new_access_code ||= loop do
          raw = Array.new(10) { ALPHANUMS.sample }.join
          break raw if AccessCode.where(access_code: raw).limit(1).empty?
        end
      end

      def create_access_code(partner)
        AccessCode.create(
          partner: partner,
          access_code: new_access_code,
        )
      end
    end
  end
end
