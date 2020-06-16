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
  end
end
