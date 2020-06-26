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

    def full_name
      values[:full_name]
    end

    def state
      values[:state]
    end

    def profile_picture_url
      # TODO: do something with values[:selfie_s3_key]
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

    def with_selfie?
      selfie_s3_key.present? && ::EmployerPortal::Aws.connected?
    end

    def selfie_s3_key
      values[:selfie_s3_key]
    end

    def selfie_url
      # TODO: needs to be cached!
      ::EmployerPortal::Aws.bucket.object(
        selfie_s3_key
      ).presigned_url :get, expires_in: 3600
    end

    def initials
      full_name.split(" ").map(&:chr).first(2).join.upcase
    end

    private

    attr_reader :context, :values
  end
end
