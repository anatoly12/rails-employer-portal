module EmployerPortal
  class EmployeeForDashboard

    # ~~ delegates ~~

    # ~~ public instance methods ~~
    def initialize(context, values)
      @context = context
      @values = values
    end

    def to_param
      values[:uuid]
    end

    def flagged?
      daily_checkup_status == "Not Cleared" || testing_status == "Inconclusive"
    end

    def full_name
      values[:full_name]
    end

    def state
      values[:state]
    end

    def daily_checkup_status
      values[:daily_checkup_status]
    end

    def daily_checkup_updated_at
      values[:daily_checkup_updated_at]
    end

    def daily_checkup_action
      values[:daily_checkup_action]
    end

    def testing_status
      values[:testing_status]
    end

    def testing_updated_at
      values[:testing_updated_at]
    end

    def selfie_url
      ::EmployerPortal::Aws.presigned_url values[:selfie_s3_key]
    end

    def initials
      full_name.split(" ").map(&:chr).first(2).join.upcase
    end

    private

    attr_reader :context, :values
  end
end
