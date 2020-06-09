class SessionsController < ApplicationController
  skip_before_action :ensure_access!, except: :destroy

  helper :form

  def show
  end

  def create
    if model.valid?
      session[:account_id] = model.account_id
      redirect_to(model.return_path || root_path)
    else
      render :show
    end
  end

private

  def permitted_params
    params.fetch(:session, {}).permit(:return_path, :username, :password)
  end

  def model
    @model ||= Session.new permitted_params
  end
  helper_method :model
end
