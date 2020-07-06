class EmployerPortal::Admin::Base::Search < ::EmployerPortal::Search

  # ~~ overrides for EmployerPortal::Search ~~
  def results
    super.map do |result|
      decorator.new context, result
    end
  end

  def sort_order
    params[:order] || "created_at:desc"
  end

  protected

  # ~~ protected methods ~~
  def decorator
    raise NotImplementedError
  end
end
