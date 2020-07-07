class Admin::UsersController < Admin::BaseController
  rescue_from ::EmployerPortal::Error::AdminUser::NotFound, with: :plan_not_found

  # ~~ collection actions ~~
  def index
  end

  def new
  end

  def create
    if editor.update_attributes params
      flash.notice = "Admin user was created successfully."
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
      flash.notice = "Admin user was updated successfully."
      redirect_to action: :index
    else
      flash.now.alert = "Please review errors and try submitting it again."
      render :edit
    end
  end

  def destroy
    if editor.myself?
      flash.alert = "You can't delete yourself."
    else
      editor.destroy
      flash.notice = "Admin user was deleted successfully."
    end
    redirect_to action: :index
  end

  private

  def plan_not_found
    flash.alert = "Admin user not found."
    redirect_to action: :index
  end

  def search
    @search ||= ::EmployerPortal::Admin::User::Search.new current_context, params
  end

  helper_method :search

  def editor
    @editor ||= ::EmployerPortal::Admin::User::Editor.from_params current_context, params
  end

  helper_method :editor
end
