class EmployeesController < ApplicationController
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
    bulk = ::EmployerPortal::EmployeeBulkImport.new(
      current_context,
      params[:file]
    )
    if bulk.has_file?
      begin
        bulk.save!
        flash.notice = "#{bulk.count} employees were imported successfully."
        redirect_to action: :index
      rescue ::EmployerPortal::Error::EmployeeBulkImport::Base => e
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
      render :new
    end
  end

  # delete

  private

  def search
    @search ||= ::EmployerPortal::EmployeeSearch.new current_context, params
  end

  helper_method :search

  def editor
    @editor ||= ::EmployerPortal::EmployeeEditor.new current_context, params
  end

  helper_method :editor
end
