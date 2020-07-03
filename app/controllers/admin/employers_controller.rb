class Admin::EmployersController < Admin::BaseController
  rescue_from ::EmployerPortal::Error::Employer::NotFound, with: :employer_not_found

  # ~~ collection actions ~~
  def index
  end

  def new
  end

  def create
    if editor.update_attributes params
      flash.notice = "Employer was created successfully."
      redirect_to action: :index
    else
      flash.now.alert = "Please review errors and try submitting it again."
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
      flash.notice = "Employer was updated successfully."
      redirect_to action: :index
    else
      flash.now.alert = "Please review errors and try submitting it again."
      render :edit
    end
  end

  def destroy
    editor.destroy
    flash.notice = "Employer was deleted successfully."
    redirect_to action: :index
  end

  private

  def employer_not_found
    flash.alert = "Employer not found."
    redirect_to action: :index
  end

  def search
    @search ||= ::EmployerPortal::Admin::Employer::Search.new current_context, params
  end

  helper_method :search

  def editor
    @editor ||= ::EmployerPortal::Admin::Employer::Editor.from_params current_context, params
  end

  helper_method :editor
end
