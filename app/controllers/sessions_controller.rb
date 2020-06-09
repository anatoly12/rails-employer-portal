class SessionsController < ApplicationController
  skip_before_action :ensure_access!, except: :destroy

  def show
  end

end
