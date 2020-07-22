class EmployeesController < ApplicationController
  before_action :ensure_sync_connected!, only: [:destroy, :reactivate]
  before_action :ensure_employee_synced!, only: [:destroy, :reactivate]
  before_action :ensure_daily_checkup_enabled!, only: [:contact, :send_reminder]
  before_action :ensure_health_passport_enabled!, only: :health_passport
  before_action :ensure_employee_access!, except: [:index, :bulk_import, :delete_all, :create, :show]
  rescue_from ::EmployerPortal::Error::Employee::NotFound, with: :employee_not_found
  rescue_from ::EmployerPortal::Error::Employee::NotSynced, with: :employee_not_synced
  rescue_from ::EmployerPortal::Error::DisabledFeature, with: :disabled_feature

  # ~~ collection actions ~~
  def index
  end

  def bulk_import
  end

  def delete_all
    return head :not_found unless Rails.env.development?

    count = search.delete_all
    flash.notice = "#{count} employees were deleted successfully."
    redirect_to action: :index
  end

  def new
  end

  def create
    bulk.has_file? ? create_bulk : create_manually
  end

  # ~~ member actions ~~
  def show
    redirect_to action: :edit
  end

  def edit
  end

  def update
    if editor.update_attributes params
      flash.notice = "Employee was updated successfully."
      redirect_to action: :index
    else
      flash.now.alert = "Please review errors and try submitting it again."
      render :edit
    end
  end

  def destroy
    if !editor.active?
      flash.alert = "Employee was already inactive."
    else
      editor.deactivate!
      flash.notice = "Employee was deactivated successfully."
    end
    redirect_to action: :edit
  end

  def reactivate
    if editor.active?
      flash.alert = "Employee was already active."
    else
      editor.reactivate!
      flash.notice = "Employee was reactivated successfully."
    end
    redirect_to action: :edit
  end

  def contact
    if editor.contact_queued?
      flash.alert = "Employee was already contacted today."
    else
      editor.contact_queue!
      flash.notice = "Employee was contacted successfully."
    end
    redirect_to action: :edit
  end

  def send_reminder
    if editor.reminder_queued?
      flash.alert = "Employee reminder was already sent today."
    else
      editor.reminder_queue!
      flash.notice = "Employee reminder was sent successfully."
    end
    redirect_to action: :edit
  end

  private

  def ensure_employee_synced!
    raise ::EmployerPortal::Error::Employee::NotSynced unless editor.synced?
  end

  def ensure_employee_access!
    editor.ensure_access!
  end

  def employee_not_found
    flash.alert = "Employee not found."
    redirect_to action: :index
  end

  def employee_not_synced
    flash.alert = "Employee has no account yet."
    redirect_to action: :edit
  end

  def disabled_feature
    flash.alert = current_context.disabled_feature_message + "."
    redirect_to action: :edit
  end

  def search
    @search ||= ::EmployerPortal::Employee::Search.from_params current_context, params
  end

  helper_method :search

  def stats
    @stats ||= ::EmployerPortal::Employee::Stats.new current_context
  end

  helper_method :stats

  def editor
    @editor ||= ::EmployerPortal::Employee::Editor.from_params current_context, params
  end

  helper_method :editor

  def bulk
    @bulk ||= ::EmployerPortal::Employee::BulkImport.from_params(
      current_context,
      params
    )
  end

  helper_method :bulk

  def create_bulk
    bulk.save!
    flash.notice = "#{bulk.count} employees were imported successfully."
    redirect_to action: :index
  rescue ::EmployerPortal::Error::Employee::BulkImport::Base => e
    flash.now.alert = e.message
    render :bulk_import
  end

  def create_manually
    ensure_employee_access!
    if editor.update_attributes params
      flash.notice = "Employee was created successfully."
      redirect_to action: :index
    else
      flash.now.alert = "Please review errors and try submitting it again."
      render :new
    end
  end
end
