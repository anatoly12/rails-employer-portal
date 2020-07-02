class Admin::EmployeesController < Admin::BaseController

  # ~~ collection actions ~~
  def index
  end

  # ~~ member actions ~~
  def retry
    CreateAccountForEmployeeJob.perform_later params[:id]
    flash.notice = "A new background job was enqueued. Please wait at least 5 minutes before retrying sync for this employee."
    redirect_to action: :index
  end

  private

  def search
    @search ||= ::EmployerPortal::Admin::Employee::Search.new(current_context, params)
  end

  helper_method :search
end
