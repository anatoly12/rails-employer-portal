class EmployeesController < PaginatedController
  # ~~ collection actions ~~
  def index
    @pagy, @employees = pagy(dataset)
  end

  def bulk_import
    index
  end

  def delete_all
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
  def show
    redirect_to action: :edit
  end

  def edit
  end

  # update/delete

  private

  def permitted_params
    params.fetch(:employee, {}).permit(:first_name, :last_name, :email, :phone, :state)
  end

  def dataset
    Employee.where employer_id: current_context.account_id
  end

  def model
    @model ||= if params[:id].present?
      dataset.where(uuid: params[:id]).limit(1).first ||
        raise(EmployerPortal::Error::Employee::NotFound)
    else
      Employee.new(permitted_params.merge(
        company_id: current_context.account.company_id,
        employer_id: current_context.account_id,
      ))
    end
  end

  helper_method :model
end
