class Admin::DashboardController < Admin::BaseController

  # ~~ collection actions ~~
  def index
  end

  private

  def dashboard_stats
    @dashboard_stats ||= ::EmployerPortal::Admin::DashboardStats.new(
      current_context
    )
  end

  helper_method :dashboard_stats
end
