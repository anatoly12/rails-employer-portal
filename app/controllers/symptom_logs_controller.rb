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

  def search
    @search ||= ::EmployerPortal::SymptomLogEntry::Search.from_params current_context, params
  end

  helper_method :search
end
