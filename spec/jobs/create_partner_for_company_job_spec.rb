require "rails_helper"

describe CreatePartnerForCompanyJob, type: :job do
  describe "#perform" do
    context "when company can't be found" do
      it "logs a message" do
        expect(Delayed::Worker.logger).to receive(:info).with "can't find company -1"
        described_class.perform_now "-1"
      end
    end

    context "when company is already synced" do
      let(:company) { create :company, remote_id: 1 }

      it "logs a message" do
        expect(Delayed::Worker.logger).to receive(:info).with "company #{company.uuid} is already linked to partner 1"
        described_class.perform_now company.uuid
      end
    end

    context "when sync is NOT connected" do
      let(:company) { create :company, remote_id: nil }

      it "raises an error" do
        expect(Delayed::Worker.logger).not_to receive(:info)
        expect do
          described_class.perform_now company.uuid
        end.to raise_error(ArgumentError, "sync isn't connected")
      end
    end

    context "when sync is connected", type: :sync do
      let(:company) { create :company, remote_id: nil }
      before { with_sync_connected }

      it "sets remote_id on company and logs a message" do
        expect(Delayed::Worker.logger).to receive(:info).with /company #{company.uuid} is now linked to partner/
        described_class.perform_now company.uuid
        expect(company.reload.remote_id).not_to be_nil
      end
    end
  end
end
