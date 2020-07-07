class EmployeesController < ApplicationController
  rescue_from ::EmployerPortal::Error::Employee::NotFound, with: :employee_not_found

  # ~~ collection actions ~~
  def index
  end

  def bulk_import
  end

  def delete_all
    dataset = Employee.where employer_id: current_context.account_id
    flash.notice = "#{dataset.count} employees were deleted successfully."
    dataset.delete
    redirect_to action: :index
  end

  def new
  end

  def create
    bulk = ::EmployerPortal::Employee::BulkImport.new(
      current_context,
      params[:file]
    )
    if bulk.has_file?
      begin
        bulk.save!
        flash.notice = "#{bulk.count} employees were imported successfully."
        redirect_to action: :index
      rescue ::EmployerPortal::Error::Employee::BulkImport::Base => e
        flash.now.alert = e.message
        render :bulk_import
      end
    elsif editor.update_attributes params
      flash.notice = "Employee was created successfully."
      redirect_to action: :index
    else
      render :new
    end
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
      render :edit
    end
  end

  def health_passport
    unless current_context.health_passport_enabled?
      flash.alert = "Feature not included in your current plan."
      redirect_to action: :edit
    end
  end

  def contact
    if editor.already_contacted?
      flash.alert = "Employee contact was already sent today."
    else
      editor.contact!
      flash.notice = "Employee contact was successfully enqueued."
    end
    redirect_to action: :edit
  end

  def send_reminder
    if editor.already_sent_reminder?
      flash.alert = "Employee reminder was already sent today."
    else
      editor.send_reminder!
      flash.notice = "Employee reminder was successfully enqueued."
    end
    redirect_to action: :edit
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

  private

  def employee_not_found
    flash.alert = "Employee not found."
    redirect_to action: :index
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
end
