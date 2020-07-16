require "rails_helper"

RSpec.describe ::EmployerPortal::Query::EmailLog do
  let(:context) { double :context }
  let(:now) { Time.now }
  let(:today) { now.to_date }
  subject { described_class.new context }

  describe "#search_dataset" do
    let(:filters) { {} }
    let(:sort_order) { "created_at:asc" }

    context "filtering" do
      let!(:email_log1) { create :email_log, trigger_key: EmailTemplate::TRIGGER_EMPLOYER_NEW, created_at: now - 1.day }
      let!(:email_log2) { create :email_log, created_at: now }

      context "by sent at >=" do
        let(:filters) { { "sent_at_gte" => today.to_s } }

        it "returns only the matching email_logs" do
          res = subject.search_dataset(filters, sort_order).all
          expect(res.map(&:id)).to eql [email_log2.id]
          expect(res[0]).to be_kind_of(EmailLog)
        end
      end

      context "by sent at <=" do
        let(:filters) { { "sent_at_lte" => (today - 1).to_s } }

        it "returns only the matching email_logs" do
          res = subject.search_dataset(filters, sort_order).all
          expect(res.map(&:id)).to eql [email_log1.id]
          expect(res[0]).to be_kind_of(EmailLog)
        end
      end

      context "by company" do
        let(:filters) { { "company_id_equals" => email_log2.company.id.to_s } }

        it "returns only the matching email_logs" do
          res = subject.search_dataset(filters, sort_order).all
          expect(res.map(&:id)).to eql [email_log2.id]
          expect(res[0]).to be_kind_of(EmailLog)
        end
      end

      context "by employer" do
        let(:filters) { { "employer_id_equals" => email_log1.employer.id.to_s } }

        it "returns only the matching email_logs" do
          res = subject.search_dataset(filters, sort_order).all
          expect(res.map(&:id)).to eql [email_log1.id]
          expect(res[0]).to be_kind_of(EmailLog)
        end
      end

      context "by employee" do
        let(:filters) { { "employee_id_equals" => email_log2.employee.id.to_s } }

        it "returns only the matching email_logs" do
          res = subject.search_dataset(filters, sort_order).all
          expect(res.map(&:id)).to eql [email_log2.id]
          expect(res[0]).to be_kind_of(EmailLog)
        end
      end

      context "by trigger key" do
        let(:filters) { { "trigger_key_equals" => EmailTemplate::TRIGGER_EMPLOYER_NEW } }

        it "returns only the matching email_logs" do
          res = subject.search_dataset(filters, sort_order).all
          expect(res.map(&:id)).to eql [email_log1.id]
          expect(res[0]).to be_kind_of(EmailLog)
        end
      end

      context "by recipient" do
        let(:filters) { { "recipient_contains" => email_log2.recipient } }

        it "returns only the matching email_logs" do
          res = subject.search_dataset(filters, sort_order).all
          expect(res.map(&:id)).to eql [email_log2.id]
          expect(res[0]).to be_kind_of(EmailLog)
        end
      end
    end
  end
end
