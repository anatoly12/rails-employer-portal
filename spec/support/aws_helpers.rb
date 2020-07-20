module AwsHelpers
  def with_aws_connected
    expect {
      ::EmployerPortal::Aws.connect
    }.to output("AWS: connected\n").to_stdout
  end
end
