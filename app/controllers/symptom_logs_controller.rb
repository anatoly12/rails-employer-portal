class SymptomLogsController < ApplicationController
  rescue_from ::EmployerPortal::Error::Employee::NotFound, with: :employee_not_found

  # ~~ member actions ~~
  def show
  end

  private

  def employee_not_found
    flash.alert = "Employee not found."
    redirect_to employees_path
  end

  def viewer
    @viewer ||= ::EmployerPortal::SymptomLog::Viewer.from_params current_context, params
  end

  helper_method :viewer
end
