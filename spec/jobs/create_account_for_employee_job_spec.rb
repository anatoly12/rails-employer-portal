require "rails_helper"

describe CreateAccountForEmployeeJob, type: :job do
  describe "#perform" do
    context "when employee can't be found" do
      it "logs a message" do
        expect(Delayed::Worker.logger).to receive(:info).with "can't find employee -1"
        described_class.perform_now "-1"
      end
    end

    context "when employee is already synced" do
      let(:employee) { create :employee, remote_id: 1 }

      it "logs a message" do
        expect(Delayed::Worker.logger).to receive(:info).with "employee #{employee.uuid} is already linked to account 1"
        described_class.perform_now employee.uuid
      end
    end

    context "when sync is NOT connected" do
      let(:employee) { create :employee }

      it "raises an error" do
        expect(Delayed::Worker.logger).not_to receive(:info)
        expect do
          described_class.perform_now employee.uuid
        end.to raise_error(ArgumentError, "sync isn't connected")
      end
    end

    context "when sync is connected", type: :sync do
      let(:employee) { create :employee }
      before { with_sync_connected }

      it "sets remote_id on employee and logs a message" do
        expect(Delayed::Worker.logger).to receive(:info).with /employee #{employee.uuid} is now linked to account/
        described_class.perform_now employee.uuid
        expect(employee.reload.remote_id).not_to be_nil
      end
    end
  end
end
