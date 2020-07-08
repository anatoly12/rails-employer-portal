require "aws-sdk-s3"

module EmployerPortal::Aws

  # ~~ constants ~~
  AWS_ACCESS_KEY_ID = ENV["AWS_ACCESS_KEY_ID"]
  AWS_SECRET_ACCESS_KEY = ENV["AWS_SECRET_ACCESS_KEY"]
  S3_PREFIX = ENV["S3_PREFIX"]
  CACHE = ::ActiveSupport::Cache::MemoryStore.new size: 1.megabyte, expires_in: 30.minutes

  class << self
    def init
      return if connected?
      log("AWS_ACCESS_KEY_ID not configured, skip") and return if AWS_ACCESS_KEY_ID.blank?
      log("AWS_SECRET_ACCESS_KEY not configured, skip") and return if AWS_SECRET_ACCESS_KEY.blank?
      ::Aws.config.update({
        region: "us-east-1",
        credentials: ::Aws::Credentials.new(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY),
      })
      log("connected")
      @connected = true
    end

    def connected?
      !!@connected
    end

    def presigned_url(key)
      return if !connected? || key.blank?

      CACHE.fetch(key) do
        bucket.object(key).presigned_url :get, expires_in: 1.hour.to_i
      end
    end

    private

    def log(message)
      puts "AWS: #{message}"
      true
    end

    def bucket
      @bucket ||= ::Aws::S3::Resource.new.bucket("ehs-portal")
    end
  end
end
