# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin_email_logs", type: :request do
  context "with an existing email log" do
    let!(:email_log) { create :email_log }

    it { is_expected.to require_admin_authentication :get, admin_email_log_path(email_log) }

    context "when authenticated" do
      before { sign_in_as_admin_user }

      it { is_expected.to render_successfully :get, admin_email_log_path(email_log) }
    end
  end

  context "trying to view a non existing email log" do
    it { is_expected.to require_admin_authentication :get, admin_email_log_path("-1") }

    context "when authenticated" do
      before { sign_in_as_admin_user }

      it "redirects to index" do
        get admin_email_log_path("-1")
        expect(response).to redirect_to admin_email_logs_path
        expect(flash[:alert]).to eql "Email log not found."
        expect(flash[:notice]).to be_nil
      end
    end
  end
end
