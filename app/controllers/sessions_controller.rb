class SessionsController < ApplicationController
  skip_before_action :ensure_access!, except: :destroy

  helper :form

  def show
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
