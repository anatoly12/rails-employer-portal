class Admin::EmailTemplatesController < Admin::BaseController
  rescue_from ::EmployerPortal::Error::EmailTemplate::NotFound, with: :email_template_not_found

  # ~~ collection actions ~~
  def index
  end

  def new
  end

  def create
    if editor.update_attributes params
      flash.notice = "Email template was created successfully."
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
      flash.notice = "Email template was updated successfully."
      redirect_to action: :index
    else
      flash.now.alert = "Please review errors and try submitting it again."
      render :edit
    end
  end

  def destroy
    editor.destroy
    flash.notice = "Email template was deleted successfully."
    redirect_to action: :index
  end

  private

  def email_template_not_found
    flash.alert = "Email template not found."
    redirect_to action: :index
  end

  def search
    @search ||= ::EmployerPortal::Admin::EmailTemplate::Search.new current_context, params
  end

  helper_method :search

  def editor
    @editor ||= ::EmployerPortal::Admin::EmailTemplate::Editor.from_params current_context, params
  end

  helper_method :editor
end
