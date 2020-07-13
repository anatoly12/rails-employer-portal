module EmployerPortal
  module Error
    class Base < ::StandardError; end
    class NotFound < Base; end
    class DisabledFeature < Base; end

    module Account
      class NotFound < ::EmployerPortal::Error::NotFound; end
    end

    module Plan
      class NotFound < ::EmployerPortal::Error::NotFound; end
    end

    module Company
      class NotFound < ::EmployerPortal::Error::NotFound; end
    end

    module Employer
      class NotFound < ::EmployerPortal::Error::NotFound; end
    end

    module Employee
      class NotFound < ::EmployerPortal::Error::NotFound; end
      class NotSynced < ::EmployerPortal::Error::Base; end

      module BulkImport
        class Base < ::EmployerPortal::Error::Base; end
        class Invalid < Base; end
      end
    end

    module AdminUser
      class NotFound < ::EmployerPortal::Error::NotFound; end
    end

    module Sync
      class Base < ::EmployerPortal::Error::Base; end
      class CantCreateAccount < Base; end
      class CantCreatePartner < Base; end
    end

    module EmailTemplate
      class NotFound < ::EmployerPortal::Error::NotFound; end
    end

    module EmailLog
      class NotFound < ::EmployerPortal::Error::NotFound; end
    end

    module Email
      class Base < ::EmployerPortal::Error::Base; end
      class InvalidTrigger < Base; end
      class NoConfiguredTemplate < Base; end
    end
  end
end
