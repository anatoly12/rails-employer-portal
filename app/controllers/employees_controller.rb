class EmployeesController < PaginatedController
  # ~~ collection actions ~~
  def index
    dataset = Employee.where employer_id: current_context.account_id
    @pagy, @employees = pagy(dataset)
  end

  def bulk_import
    index
  end

  def delete_all
    dataset = Employee.where(employer_id: current_context.account_id)
    flash.notice = "#{dataset.count} employees were deleted successfully."
    dataset.delete
    redirect_to action: :index
  end

  def new
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
    elsif model.save raise_on_failure: false
      flash.notice = "Employee was created successfully."
      redirect_to action: :index
    else
      render :new
    end
  end

  # ~~ member actions ~~
  # show/edit/delete

  private

  def permitted_params
    params.fetch(:employee, {}).permit(:first_name, :last_name, :email, :phone, :state)
  end

  def model
    @model ||= Employee.new(permitted_params.merge(
      company_id: current_context.account.company_id,
      employer_id: current_context.account_id,
    ))
  end

  helper_method :model
end
