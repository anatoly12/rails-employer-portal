module EmployerPortal
  class HealthPassport

    # ~~ delegates ~~
    delegate :to_param, to: :employee

    # ~~ public instance methods ~~
    def initialize(context, employee, dashboard_employee)
      @context = context
      @employee = employee
      @dashboard_employee = dashboard_employee
    end

    def full_name
      dashboard_employee&.full_name || "#{employee.first_name} #{employee.last_name}"
    end

    def daily_checkup_updated_at
      time = dashboard_employee&.daily_checkup_updated_at
      time ? time.strftime("%F") : "Never"
    end

    def testing_updated_at
      time = dashboard_employee&.testing_updated_at
      time ? time.strftime("%F") : "Never"
    end

    def selfie_url
      ::EmployerPortal::Aws.presigned_url dashboard_employee&.selfie_s3_key
    end

    def initials
      full_name.split(" ").map(&:chr).first(2).join.upcase
    end

    def identity_verified?
      !!dashboard_employee&.identity_verified
    end

    def cleared?
      daily_checkup_status == "Cleared" && testing_status == "Cleared"
    end

    private

    attr_reader :context, :employee, :dashboard_employee

    def daily_checkup_status
      dashboard_employee&.daily_checkup_status || "Did Not Submit"
    end

    def testing_status
      dashboard_employee&.testing_status || "Not Registered"
    end
  end
end
