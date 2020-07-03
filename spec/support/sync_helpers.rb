module SyncHelpers
  def with_sync_connected
    url = "mysql2://@localhost:3306/ecp-test?charset=utf8&collation=utf8_general_ci"
    stub_const "EmployerPortal::Sync::SYNC_DATABASE_URL", url
    expect {
      silence { ::EmployerPortal::Sync.connect }
    }.not_to raise_error
    expect(::EmployerPortal::Sync).to be_connected
  end

  private

  def silence
    raise ArgumentError, "block is required" unless block_given?
    $stdout = $stderr = captured = StringIO.new
    yield
    captured.string
  ensure
    $stdout = STDOUT
    $stderr = STDERR
  end
end
