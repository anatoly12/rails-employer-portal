class SessionsController < ApplicationController
  skip_before_action :ensure_access!, except: :destroy
  before_action :redirect_if_signed_in, except: :destroy

  def show
  end

  def create
    if editor.valid?
      session[:account_id] = editor.account_id
      redirect_to(editor.return_path || root_path)
    else
      flash.now.alert = "Please review errors and try submitting it again."
      render :show
    end
  end

  def destroy
    reset_session
    redirect_to action: :show
  end

  private

  def redirect_if_signed_in
    redirect_to root_path if current_context.signed_in?
  end

  def editor_params
    params.fetch(:session, {}).permit(:return_path, :username, :password)
  end

  def editor
    @editor ||= ::EmployerPortal::SessionEditor.new editor_params
  end

  helper_method :editor
end
