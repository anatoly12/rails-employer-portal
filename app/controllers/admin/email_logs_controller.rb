class Admin::EmailLogsController < Admin::BaseController
  rescue_from ::EmployerPortal::Error::EmailLog::NotFound, with: :email_log_not_found

  # ~~ collection actions ~~
  def index
  end

  # ~~ member actions ~~
  def show
  end

  private

  def email_log_not_found
    flash.alert = "Email log not found."
    redirect_to action: :index
  end

  def search
    @search ||= ::EmployerPortal::Admin::EmailLog::Search.new current_context, params
  end

  helper_method :search

  def viewer
    @viewer ||= ::EmployerPortal::Admin::EmailLog::Viewer.from_params current_context, params
  end

  helper_method :viewer
end
