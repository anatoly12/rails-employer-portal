class ApplicationController < ActionController::Base
  helper :css_class

  before_action :ensure_access!
  rescue_from ::EmployerPortal::Error::Account::NotFound, with: :account_not_found

  def check
    head :ok
  end

  private

  def current_context
    @current_context ||= ::EmployerPortal::Context.new(
      account_id: session[:account_id],
    )
  end

  helper_method :current_context

  def ensure_access!
    current_context.ensure_access!
  end

  def account_not_found
    return_path = (request.fullpath unless controller_path == "sessions")
    return_path = nil if return_path == "/"
    session_params = { return_path: return_path } if return_path
    redirect_to_without_cache sessions_path(session: session_params)
  end

  def redirect_to_without_cache(to)
    redirect_to to
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate" # HTTP 1.1
    response.headers["Pragma"] = "no-cache" # HTTP 1.0
    response.headers["Expires"] = "0" # Proxies
  end
end
