require "rails_helper"

RSpec.describe ::EmployerPortal::Sync, order: :defined do
  before { stub_const("#{described_class}::SYNC_DATABASE_URL", url) }

  context "when SYNC_DATABASE_URL isn't defined" do
    let(:url) { "" }

    it "skips sync" do
      expect(described_class.schema_name).to eql ""
      expect do
        expect { described_class.init }.not_to raise_error
      end.to output("Sync: SYNC_DATABASE_URL not configured, skip\n").to_stdout
      expect(described_class).not_to be_connected
    end
  end

  context "when SYNC_DATABASE_URL isn't a valid URL" do
    let(:url) { "invalid URL" }

    it "aborts the process" do
      expect { described_class.schema_name }.to raise_error URI::InvalidURIError
      expect do
        expect { described_class.init }.to raise_error SystemExit
      end.to output("Sync: can't connect to #{url}\n").to_stderr
      expect(described_class).not_to be_connected
    end
  end

  context "when SYNC_DATABASE_URL is defined" do
    let(:url) { "mysql2://@localhost:3306/ecp-test?charset=utf8&collation=utf8_general_ci" }

    it "extracts schema_name" do
      expect(described_class.schema_name).to eql "ecp-test"
      expect do
        expect { described_class.init }.not_to raise_error
      end.to output("Sync: connected to ecp-test\n").to_stdout
      expect(described_class).to be_connected
    end
  end
end
