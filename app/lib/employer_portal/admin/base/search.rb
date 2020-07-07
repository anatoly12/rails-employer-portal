class EmployerPortal::Admin::Base::Search < ::EmployerPortal::Search

  # ~~ overrides for EmployerPortal::Search ~~
  def sort_order
    params[:order] || "created_at:desc"
  end
end
