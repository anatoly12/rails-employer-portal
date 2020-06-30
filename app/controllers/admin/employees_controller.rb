class Admin::EmployeesController < Admin::BaseController

  # ~~ collection actions ~~
  def index
  end

  private

  def search
    @search ||= ::EmployerPortal::Admin::EmployeeSearch.new(current_context, params)
  end

  helper_method :search
end
