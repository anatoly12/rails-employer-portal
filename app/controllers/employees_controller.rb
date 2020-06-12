class EmployeesController < ApplicationController
  def index
  end

  def bulk_import
  end

  def create
    bulk = EmployerPortal::EmployeeBulkImport.new(
      current_context.account,
      params[:file]
    )
    if bulk.has_file?
      begin
        csv = bulk.csv
        flash.notice = "#{csv.size} employees were imported successfully."
        redirect_to action: :index
      rescue StandardError => e
        flash.now.alert = e.message
        render :bulk_import
      end
    else
      raise "manual create"
    end
  end

  def delete_all
    dataset = Employee.where(employer_id: current_context.account_id)
    flash.notice = "#{dataset.count} employees were deleted successfully."
    dataset.delete
    redirect_to action: :index
  end

  private

  def employees
    Employee.where(employer_id: current_context.account_id).all
  end

  helper_method :employees
end
