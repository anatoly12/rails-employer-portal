class ResetPasswordsController < ApplicationController
  skip_before_action :ensure_access!
  before_action :check_token!, only: [:edit, :update]

  def index
    redirect_to action: :new
  end

  def new
  end

  def create
    if editor.valid?
      editor.trigger!
      flash.notice = "If your email address exists in our database, you should receive a password recovery link soon."
      redirect_to sessions_path
    else
      flash.now.alert = "Please review errors and try submitting it again."
      render :new
    end
  end

  def show
    redirect_to action: :edit, reset_password: editor_params
  end

  def edit
  end

  def update
    if editor.update_password
      flash.notice = "Your password was updated successfully."
      session[:account_id] = editor.account_id
      redirect_to root_path
    else
      flash.now.alert = "Please review errors and try submitting it again."
      render :edit
    end
  end

  private

  def check_token!
    return if editor.valid_token? params[:id]

    flash.alert = "Your reset password token is invalid or expired. Please try again."
    redirect_to action: :new
  end

  def editor_params
    params.fetch(:reset_password, {}).permit :email, :password
  end

  def editor
    @editor ||= ::EmployerPortal::Employer::ResetPassword.new editor_params
  end

  helper_method :editor
end
