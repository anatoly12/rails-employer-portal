module EmployerPortal
  module Error
    class Base < ::StandardError; end
    class NotFound < Base; end

    module Account
      class NotFound < ::EmployerPortal::Error::NotFound; end
    end

    module Employee
      class NotFound < ::EmployerPortal::Error::NotFound; end
    end

    module EmployeeBulkImport
      class Base < ::EmployerPortal::Error::Base; end
      class Invalid < Base; end
    end

    module Sync
      class Base < ::EmployerPortal::Error::Base; end
      class CantCreateAccount < Base; end
    end
  end
end
