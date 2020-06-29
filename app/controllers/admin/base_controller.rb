class Admin::BaseController < ApplicationController
  layout "admin"

  protected

  # ~~ overrides for ApplicationController ~~
  def current_context
    @current_context ||= ::EmployerPortal::Context.new(
      account_id: session[:admin_account_id],
      section: :admin,
    )
  end

  def account_not_found
    redirect_to_without_cache admin_sessions_path
  end
end
