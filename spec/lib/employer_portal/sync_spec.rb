require "rails_helper"

RSpec.describe ::EmployerPortal::Sync, type: :sync, order: :defined do
  describe ".connect" do
    before(:all) do
      Sequel::Model.db.drop_view(
        :dashboard_employees,
        :symptom_logs,
        :symptom_log_entries,
        if_exists: true,
      )
    end
    before { stub_const("#{described_class}::SYNC_DATABASE_URL", url) }
    subject { described_class.connect }

    context "when SYNC_DATABASE_URL isn't defined" do
      let(:url) { "" }

      it "skips sync" do
        expect(described_class.schema_name).to eql ""
        expect do
          expect { subject }.not_to raise_error
        end.to output("Sync: SYNC_DATABASE_URL not configured, skip\n").to_stdout
        expect(described_class).not_to be_connected
      end
    end

    context "when SYNC_DATABASE_URL isn't a valid URL" do
      let(:url) { "invalid URL" }

      it "aborts the process" do
        expect { described_class.schema_name }.to raise_error URI::InvalidURIError
        expect do
          expect { subject }.to raise_error SystemExit
        end.to output("Sync: can't connect to #{url}\n").to_stderr
        expect(described_class).not_to be_connected
      end
    end

    context "when SYNC_DATABASE_URL is defined" do
      let(:url) { "mysql2://@localhost:3306/ecp-test?charset=utf8&collation=utf8_general_ci" }
      let(:db) { Sequel::Model.db }

      it "extracts schema_name" do
        expect(described_class.schema_name).to eql "ecp-test"
      end

      it "connects successfully" do
        expect do
          expect { subject }.not_to raise_error
        end.to output("Sync: connected to ecp-test\n").to_stdout
        expect(described_class).to be_connected
      end

      it "creates dashboard_employees view" do
        expect(db.table_exists?(:dashboard_employees)).to be true
        expect(db[:dashboard_employees].all).to be_empty
      end

      it "creates symptom_logs view" do
        expect(db.table_exists?(:symptom_logs)).to be true
        expect(db[:symptom_logs].all).to be_empty
      end

      it "creates symptom_log_entries view" do
        expect(db.table_exists?(:symptom_log_entries)).to be true
        expect(db[:symptom_log_entries].all).to be_empty
      end
    end
  end

  describe ".create_account_for_employee!" do
    let(:company) { create :company }
    let(:employee) { create :employee, company: company }
    before do
      stub_const(
        "#{described_class}::SYNC_DATABASE_URL",
        "mysql2://@localhost:3306/ecp-test?charset=utf8&collation=utf8_general_ci"
      )
      expect { described_class.connect }.not_to output.to_stdout # already connected
    end

    before { described_class::Account.dataset.delete }
    subject { described_class.create_account_for_employee! employee }

    context "when SYNC_SECRET_KEY_BASE isn't defined" do
      before { stub_const("#{described_class}::SYNC_SECRET_KEY_BASE", "") }

      it "raises an error" do
        expect do
          subject
        end.to raise_error ArgumentError, "SYNC_SECRET_KEY_BASE not configured"
      end
    end

    context "when SYNC_SECRET_KEY_BASE is defined" do
      context "when employee has no account yet" do
        it "creates a new account" do
          expect do
            subject
          end.to change { described_class::Account.count }.by(1)
          account = described_class::Account.order(:id).last
          expect(account.email).to eql employee.email
          expect(account.is_active).to be_truthy
          expect(account.reset_password_token).not_to be_nil
        end

        it "creates a legacy user too" do
          subject
          user = described_class::Account.order(:id).last.user
          expect(user.email).to eql employee.email
          expect(user.first_name).to eql employee.first_name
          expect(user.last_name).to eql employee.last_name
        end

        it "creates a row in account demographics" do
          subject
          demographic = described_class::Account.order(:id).last.demographic
          expect(demographic.full_legal_name).to eql "#{employee.first_name} #{employee.last_name}"
          expect(demographic.state_of_residence).to eql employee.state
          expect(demographic.phone_number).to eql employee.phone
        end

        context "when company.remote_id isn't filled in" do
          it "doesn't create any kit" do
            expect { subject }.not_to change { described_class::Kit.count }
          end

          it "doesn't create any requisition" do
            expect { subject }.not_to change { described_class::Requisition.count }
          end

          it "doesn't create any access grant" do
            expect { subject }.not_to change { described_class::AccessGrant.count }
          end
        end

        context "when company.remote_id doesn't match any access code" do
          let(:partner) { create :sync_partner }
          let(:company) { create :company, remote_id: partner.partner_id }

          it "doesn't create any kit" do
            expect { subject }.not_to change { described_class::Kit.count }
          end

          it "doesn't create any requisition" do
            expect { subject }.not_to change { described_class::Requisition.count }
          end

          it "doesn't create any access grant" do
            expect { subject }.not_to change { described_class::AccessGrant.count }
          end
        end

        context "when company.remote_id matches an access code" do
          let(:partner) { create :sync_partner }
          let(:company) { create :company, remote_id: partner.partner_id }
          let!(:access_code) { create :sync_access_code, partner: partner }

          it "doesn't create any kit" do
            expect { subject }.not_to change { described_class::Kit.count }
          end

          it "doesn't create any requisition" do
            expect { subject }.not_to change { described_class::Requisition.count }
          end

          it "creates an access grant" do
            expect do
              subject
            end.to change { described_class::AccessGrant.count }.by(1)
            account = described_class::Account.order(:id).last
            expect(account.access_grants.size).to eql 1
            access_grant = account.access_grants.first
            expect(access_grant.partner_access_code_id).to eql access_code.id
          end
        end

        context "when company.remote_id matches a passport product" do
          let(:passport_product) { create :sync_passport_product }
          let(:partner) { create :sync_partner, passport_product: passport_product }
          let(:company) { create :company, remote_id: partner.partner_id }

          it "creates a kit" do
            expect do
              subject
            end.to change { described_class::Kit.count }.by(1)
          end

          it "creates a requisition" do
            expect do
              subject
            end.to change { described_class::Requisition.count }.by(1)
          end

          it "doesn't create any access grant" do
            expect { subject }.not_to change { described_class::AccessGrant.count }
          end
        end

        it "links the employee to the new account" do
          subject
          expect(employee.remote_id).not_to be_nil
          expect(employee.remote_sync_at).not_to be_nil
        end

        it "spawns an email trigger job" do
          expect { subject }.to have_enqueued_job(EmailTriggerJob).with(
            "employee_new",
            employee.id,
            hash_including("reset_password_token")
          )
        end
      end

      context "when employee already has an account" do
        let!(:account) { create :sync_account, email: employee.email }

        it "doesn't create any account" do
          expect do
            subject
          end.not_to change { described_class::Account.count }
        end

        it "reactivates the account if needed" do
          account.update is_active: false
          subject
          expect(account.reload.is_active).to be_truthy
        end

        it "links the employee to the existing account" do
          subject
          expect(employee.remote_id).to eql account.id
          expect(employee.remote_sync_at).not_to be_nil
        end

        context "with an existing demographic" do
          let!(:demographic) { create :sync_demographic, account: account }

          it "doesn't create any demographic" do
            expect do
              subject
            end.not_to change { described_class::Demographic.count }
          end

          it "doesn't update the existing demographic" do
            expect do
              subject
            end.not_to change { demographic.reload }
          end
        end

        context "without demographic" do
          it "creates a new demographic for the existing account" do
            expect do
              subject
            end.to change { described_class::Demographic.count }.by(1)
            demographic = account.demographic
            expect(demographic.full_legal_name).to eql "#{employee.first_name} #{employee.last_name}"
            expect(demographic.state_of_residence).to eql employee.state
            expect(demographic.phone_number).to eql employee.phone
          end
        end

        context "with an existing access grant with this partner" do
          let(:partner) { create :sync_partner }
          let(:company) { create :company, remote_id: partner.partner_id }
          let(:access_code) { create :sync_access_code, partner: partner }
          let!(:access_grant) { create :sync_access_grant, account: account, access_code: access_code }

          it "doesn't create any access grant" do
            expect do
              subject
            end.not_to change { described_class::AccessGrant.count }
          end

          it "doesn't update the existing access grant" do
            expect do
              subject
            end.not_to change { access_grant.reload }
          end
        end

        context "with an existing access grant but with another partner" do
          let(:partner) { create :sync_partner }
          let(:company) { create :company, remote_id: partner.partner_id }
          let!(:access_code) { create :sync_access_code, partner: partner }
          let(:another_access_code) { create :sync_access_code, partner: create(:sync_partner) }
          let!(:access_grant) { create :sync_access_grant, account: account, access_code: another_access_code }

          it "creates an access grant for the existing account" do
            expect do
              subject
            end.to change { account.reload.access_grants.size }.from(1).to(2)
            access_grant = account.access_grants.last
            expect(access_grant.partner_access_code_id).to eql access_code.id
          end
        end

        context "without existing access grant" do
          let(:partner) { create :sync_partner }
          let(:company) { create :company, remote_id: partner.partner_id }
          let!(:access_code) { create :sync_access_code, partner: partner }

          it "creates an access grant for the existing account" do
            expect do
              subject
            end.to change { account.reload.access_grants.size }.by(1)
            access_grant = account.access_grants.first
            expect(access_grant.partner_access_code_id).to eql access_code.id
          end
        end

        context "with an existing kit with this partner" do
          let(:passport_product) { create :sync_passport_product }
          let(:partner) { create :sync_partner, passport_product: passport_product }
          let(:company) { create :company, remote_id: partner.partner_id }
          let(:requisition) { create :sync_requisition, user: account.user }
          let!(:kit) { create :sync_kit, t_kit: passport_product.t_kit, requisition: requisition, partner: partner }

          it "doesn't create any kit" do
            expect do
              subject
            end.not_to change { described_class::Kit.count }
          end

          it "doesn't create any requisition" do
            expect do
              subject
            end.not_to change { described_class::Requisition.count }
          end
        end

        context "with an existing kit but with another partner" do
          let(:passport_product) { create :sync_passport_product }
          let(:partner) { create :sync_partner, passport_product: passport_product }
          let(:company) { create :company, remote_id: partner.partner_id }
          let(:requisition) { create :sync_requisition, user: account.user }
          let!(:kit) { create :sync_kit, t_kit: passport_product.t_kit, requisition: requisition, partner: create(:sync_partner) }

          it "creates a kit" do
            expect do
              subject
            end.to change { described_class::Kit.count }.by(1)
          end

          it "creates a requisition" do
            expect do
              subject
            end.to change { described_class::Requisition.count }.by(1)
          end
        end

        context "without existing kit" do
          let(:passport_product) { create :sync_passport_product }
          let(:partner) { create :sync_partner, passport_product: passport_product }
          let(:company) { create :company, remote_id: partner.partner_id }

          it "creates a kit" do
            expect do
              subject
            end.to change { described_class::Kit.count }.by(1)
          end

          it "creates a requisition" do
            expect do
              subject
            end.to change { described_class::Requisition.count }.by(1)
          end
        end
      end

      context "when account creation fails" do
        let(:employee) { build :employee, email: nil }

        it "raises an error" do
          expect { subject }.to raise_error(
            ::EmployerPortal::Error::Sync::CantCreateAccount,
            "Mysql2::Error: Column 'email' cannot be null"
          )
        end

        it "doesn't create any account" do
          expect do
            expect { subject }.to raise_error ::EmployerPortal::Error::Sync::CantCreateAccount
          end.not_to change { described_class::Account.count }
        end
      end
    end
  end
end
