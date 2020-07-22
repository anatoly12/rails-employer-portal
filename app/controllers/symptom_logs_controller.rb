class SymptomLogsController < ApplicationController
  before_action :ensure_sync_connected!
  before_action :ensure_employee_synced!
  before_action :ensure_daily_checkup_enabled!
  before_action :ensure_employee_access!
  rescue_from ::EmployerPortal::Error::Employee::NotFound, with: :employee_not_found
  rescue_from ::EmployerPortal::Error::Employee::NotSynced, with: :employee_not_synced
  rescue_from ::EmployerPortal::Error::DisabledFeature, with: :disabled_feature

  # ~~ member actions ~~
  def show
  end

  private

  def ensure_employee_synced!
    raise ::EmployerPortal::Error::Employee::NotSynced unless search.employee_editor.synced?
  end

  def ensure_employee_access!
    search.employee_editor.ensure_access!
  end

  def employee_not_found
    flash.alert = "Employee not found."
    redirect_to employees_path
  end

  def search
    @search ||= ::EmployerPortal::SymptomLogEntry::Search.from_params current_context, params
  end

  helper_method :search

  def employee_not_synced
    flash.alert = "Employee has no account yet."
    redirect_to edit_employee_path(params[:employee_id])
  end

  def disabled_feature
    flash.alert = current_context.disabled_feature_message + "."
    redirect_to edit_employee_path(params[:employee_id])
  end
end
