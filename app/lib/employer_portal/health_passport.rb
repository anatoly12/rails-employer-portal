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

    def in_step?(label)
      if label == "Passport Complete"
        status_cleared? || status_not_cleared?
      else
        testing_status == label
      end
    end

    def status
      status_not_cleared? ? "Not Cleared" : testing_status
    end

    def status_cleared?
      testing_status == "Cleared"
    end

    def status_not_cleared?
      testing_status == "Inconclusive"
    end

    private

    attr_reader :context, :employee, :dashboard_employee

    def testing_status
      dashboard_employee&.testing_status || "Not Registered"
    end
  end
end
