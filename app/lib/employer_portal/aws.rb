require "aws-sdk-s3"

module EmployerPortal
  module Aws
    AWS_ACCESS_KEY_ID = ENV["AWS_ACCESS_KEY_ID"]
    AWS_SECRET_ACCESS_KEY = ENV["AWS_SECRET_ACCESS_KEY"]
    S3_PREFIX = ENV["S3_PREFIX"]

    class << self
      def init
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

      def bucket
        @bucket ||= ::Aws::S3::Resource.new.bucket("ehs-portal")
      end

      private

      def log(message)
        puts "AWS: #{message}"
        true
      end
    end
  end
end
