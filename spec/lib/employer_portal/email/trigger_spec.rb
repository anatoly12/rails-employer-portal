require "rails_helper"

RSpec.describe ::EmployerPortal::Email::Trigger do
  include SyncHelpers
  let(:context) { ::EmployerPortal::Context.new account_id: nil, section: :background_job }
  let(:company) { create :company }
  let(:employer) { create :employer, company: company }
  let(:employee) { create :employee, company: company, employer: employer }
  let(:another_plan) { create :plan }
  let(:recipient_id) { -1 }
  let(:opts) { {} }
  subject { described_class.new context, trigger_key, recipient_id, opts }

  context "invalid trigger_key" do
    let(:trigger_key) { "invalid" }

    it "raises an error" do
      expect { subject.send_all }.to raise_error(::EmployerPortal::Error::Email::InvalidTrigger, "doesn't know how to find recipient for invalid").and change(ActionMailer::Base.deliveries, :count).by(0).and change(EmailLog, :count).by(0)
    end
  end

  context "when recipient is employer" do
    let(:trigger_key) { EmailTemplate::TRIGGER_EMPLOYER_NEW }

    context "when employer can't be found" do
      it "raises an error" do
        expect { subject.send_all }.to raise_error(::EmployerPortal::Error::Employer::NotFound).and change(ActionMailer::Base.deliveries, :count).by(0).and change(EmailLog, :count).by(0)
      end
    end

    context "when employer can be found" do
      let(:recipient_id) { employer.uuid }

      context "without template" do
        it "raises an error" do
          expect { subject.send_all }.to raise_error(::EmployerPortal::Error::Email::NoConfiguredTemplate).and change(ActionMailer::Base.deliveries, :count).by(0).and change(EmailLog, :count).by(0)
        end
      end

      context "with a template for all plans" do
        let(:another_plan) { create :plan }
        let!(:email_template) { create :email_template, trigger_key: trigger_key }

        it "sends an email" do
          expect { subject.send_all }.to change(ActionMailer::Base.deliveries, :count).by(1)
          email = ActionMailer::Base.deliveries.last
          expect(email.subject).to eq email_template.subject
          expect(email.header["From"].to_s).to eq email_template.from
          expect(email.header["Reply-To"].to_s).to eq email_template.from
          expect(email.to).to eq [employer.email]
          expect(email.html_part.body.to_s).to eq email_template.html
          expect(email.text_part.body.to_s).to eq email_template.text
        end

        it "creates an email log" do
          expect { subject.send_all }.to change(EmailLog, :count).by(1)
          email_log = EmailLog.order(:id).last
          expect(email_log.email_template_id).to eql email_template.id
          expect(email_log.company_id).to eql employer.company_id
          expect(email_log.employer_id).to eql employer.id
          expect(email_log.employee_id).to be_nil
          expect(email_log.trigger_key).to eql trigger_key
          expect(email_log.from).to eql email_template.from
          expect(email_log.recipient).to eql employer.email
          expect(email_log.subject).to eql email_template.subject
          expect(email_log.html).to eql email_template.html
          expect(email_log.text).to eql email_template.text
          expect(email_log.covid19_message_id).to be_nil
        end

        it "returns the email logs" do
          logs = subject.send_all
          expect(logs.size).to eql 1
          expect(logs[0]).to eql EmailLog.order(:id).last
        end

        context "with some options" do
          let(:opts) { { "password" => "12345" } }

          it "passes down these options to the composer" do
            expect(EmployerPortal::Email::Composer).to receive(:new).with(
              context,
              email_template,
              employer,
              "password" => "12345",
            ).and_call_original
            subject.send_all
          end
        end
      end

      context "with a template for another plan" do
        let!(:email_template) { create :email_template, trigger_key: trigger_key, plan: another_plan }

        it "raises an error" do
          expect { subject.send_all }.to raise_error(::EmployerPortal::Error::Email::NoConfiguredTemplate).and change(ActionMailer::Base.deliveries, :count).by(0).and change(EmailLog, :count).by(0)
        end
      end

      context "with a template for same plan" do
        let!(:email_template) { create :email_template, trigger_key: trigger_key, plan: employer.company.plan }

        it "sends an email" do
          expect { subject.send_all }.to change(ActionMailer::Base.deliveries, :count).by(1).and change(EmailLog, :count).by(1)
        end
      end

      context "when sync isn't connected" do
        context "when email template has a covid19_message_code configured" do
          let!(:email_template) { create :email_template, trigger_key: trigger_key, covid19_message_code: -1 }

          it "doesn't raise any error" do
            expect { subject.send_all }.not_to raise_error
          end
        end
      end

      context "when sync is connected", type: :sync do
        before { with_sync_connected }

        context "when email template has a covid19_message_code configured" do
          let(:covid19_message_code) { create :sync_covid19_message_code }
          let!(:email_template) { create :email_template, trigger_key: trigger_key, covid19_message_code: covid19_message_code.message_code }

          it "doesn't add any covid19_messages" do
            expect { subject.send_all }.not_to change(::EmployerPortal::Sync::Covid19Message, :count)
          end
        end
      end

      context "if the email can't be sent" do
        let!(:email_template) { create :email_template, trigger_key: trigger_key }
        before do
          employer.email = nil
          employer.save validate: false
        end

        it "sends no email" do
          expect { subject.send_all }.to raise_error(ArgumentError, "SMTP To address may not be blank: []").and change(ActionMailer::Base.deliveries, :count).by(0).and change(EmailLog, :count).by(0)
        end
      end
    end
  end

  context "when recipient is employee" do
    let(:trigger_key) { EmailTemplate::TRIGGER_EMPLOYEE_NEW }

    context "when employee can't be found" do
      it "raises an error" do
        expect { subject.send_all }.to raise_error(::EmployerPortal::Error::Employee::NotFound).and change(ActionMailer::Base.deliveries, :count).by(0).and change(EmailLog, :count).by(0)
      end
    end

    context "when employee can be found" do
      let(:recipient_id) { employee.uuid }

      context "without template" do
        it "raises an error" do
          expect { subject.send_all }.to raise_error(::EmployerPortal::Error::Email::NoConfiguredTemplate).and change(ActionMailer::Base.deliveries, :count).by(0).and change(EmailLog, :count).by(0)
        end
      end

      context "with a template for all plans" do
        let(:another_plan) { create :plan }
        let!(:email_template) { create :email_template, trigger_key: trigger_key }

        it "sends an email" do
          expect { subject.send_all }.to change(ActionMailer::Base.deliveries, :count).by(1)
          email = ActionMailer::Base.deliveries.last
          expect(email.subject).to eq email_template.subject
          expect(email.header["From"].to_s).to eq email_template.from
          expect(email.header["Reply-To"].to_s).to eq email_template.from
          expect(email.to).to eq [employee.email]
          expect(email.html_part.body.to_s).to eq email_template.html
          expect(email.text_part.body.to_s).to eq email_template.text
        end

        it "creates an email log" do
          expect { subject.send_all }.to change(EmailLog, :count).by(1)
          email_log = EmailLog.order(:id).last
          expect(email_log.email_template_id).to eql email_template.id
          expect(email_log.company_id).to eql employee.company_id
          expect(email_log.employer_id).to eql employee.employer_id
          expect(email_log.employee_id).to eql employee.id
          expect(email_log.trigger_key).to eql trigger_key
          expect(email_log.from).to eql email_template.from
          expect(email_log.recipient).to eql employee.email
          expect(email_log.subject).to eql email_template.subject
          expect(email_log.html).to eql email_template.html
          expect(email_log.text).to eql email_template.text
          expect(email_log.covid19_message_id).to be_nil
        end

        it "returns the email logs" do
          logs = subject.send_all
          expect(logs.size).to eql 1
          expect(logs[0]).to eql EmailLog.order(:id).last
        end

        context "with some options" do
          let(:opts) { { "password" => "12345" } }

          it "passes down these options to the composer" do
            expect(EmployerPortal::Email::Composer).to receive(:new).with(
              context,
              email_template,
              employee,
              "password" => "12345",
            ).and_call_original
            subject.send_all
          end
        end
      end

      context "with a template for another plan" do
        let!(:email_template) { create :email_template, trigger_key: trigger_key, plan: another_plan }

        it "raises an error" do
          expect { subject.send_all }.to raise_error(::EmployerPortal::Error::Email::NoConfiguredTemplate).and change(ActionMailer::Base.deliveries, :count).by(0).and change(EmailLog, :count).by(0)
        end
      end

      context "with a template for same plan" do
        let!(:email_template) { create :email_template, trigger_key: trigger_key, plan: employer.company.plan }

        it "sends an email" do
          expect { subject.send_all }.to change(ActionMailer::Base.deliveries, :count).by(1).and change(EmailLog, :count).by(1)
        end
      end

      context "when sync isn't connected" do
        context "when email template has a covid19_message_code configured" do
          let!(:email_template) { create :email_template, trigger_key: trigger_key, covid19_message_code: -1 }

          it "doesn't raise any error" do
            expect { subject.send_all }.not_to raise_error
          end
        end
      end

      context "when sync is connected", type: :sync do
        before { with_sync_connected }

        context "when email template has a covid19_message_code configured" do
          let(:covid19_message_code) { create :sync_covid19_message_code }
          let!(:email_template) { create :email_template, trigger_key: trigger_key, covid19_message_code: covid19_message_code.message_code }

          context "when employee hasn't been synced yet" do
            it "doesn't add any covid19_messages" do
              expect { subject.send_all }.not_to change(::EmployerPortal::Sync::Covid19Message, :count)
            end
          end

          context "when employee has a been synced" do
            let(:partner) { create :sync_partner }
            let(:company) { create :company, remote_id: partner.partner_id }
            let(:employee) { create :employee, company: company, employer: employer, remote_id: -1 }
            before do
              ::EmployerPortal::Sync::create_account_for_employee! employee
              expect(employee.remote_id).not_to be_nil
            end

            it "adds a covid19_messages" do
              expect { subject.send_all }.to change(::EmployerPortal::Sync::Covid19Message, :count).by(1)
              message = ::EmployerPortal::Sync::Covid19Message.order(:covid19_message_id).last
              expect(message.account_id).to eql employee.remote_id
              expect(message.message_code).to eql covid19_message_code.message_code
            end
          end
        end
      end

      context "if the email can't be sent" do
        let!(:email_template) { create :email_template, trigger_key: trigger_key }
        before do
          employee.email = nil
          employee.save validate: false
        end

        it "sends no email" do
          expect { subject.send_all }.to raise_error(ArgumentError, "SMTP To address may not be blank: []").and change(ActionMailer::Base.deliveries, :count).by(0).and change(EmailLog, :count).by(0)
        end
      end
    end
  end
end
