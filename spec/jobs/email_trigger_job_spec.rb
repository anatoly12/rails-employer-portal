require "rails_helper"

describe EmailTriggerJob, type: :job do
  let(:trigger_key) { "trigger_key" }
  let(:recipient_id) { "recipient_id" }
  let(:opts) { {} }

  describe "#perform" do
    let(:email_trigger) { double :email_trigger }
    before do
      allow(::EmployerPortal::Email::Trigger).to receive(:new).with(
        an_instance_of(::EmployerPortal::Context),
        trigger_key,
        recipient_id,
        opts
      ).and_return email_trigger
    end

    context "when email trigger service raises an error" do
      before { allow(email_trigger).to receive(:send_all).and_raise ::EmployerPortal::Error::Email::InvalidTrigger }

      it "bubbles the error up" do
        expect(Delayed::Worker.logger).not_to receive :info
        expect do
          described_class.perform_now trigger_key, recipient_id, opts
        end.to raise_error ::EmployerPortal::Error::Email::InvalidTrigger
      end
    end

    context "when email trigger service returns no email log" do
      before { expect(email_trigger).to receive(:send_all).and_return [] }

      it "logs a message" do
        expect(Delayed::Worker.logger).to receive(:info).with "Email trigger trigger_key: 0 email(s) sent"
        described_class.perform_now trigger_key, recipient_id, opts
      end
    end

    context "when email trigger service returns email logs" do
      let(:email_log1) { create :email_log }
      let(:email_log2) { create :email_log }
      before { expect(email_trigger).to receive(:send_all).and_return [email_log1, email_log2] }

      it "logs a message" do
        expect(Delayed::Worker.logger).to receive(:info).with "Email trigger trigger_key: 2 email(s) sent"
        described_class.perform_now trigger_key, recipient_id, opts
      end
    end
  end
end
