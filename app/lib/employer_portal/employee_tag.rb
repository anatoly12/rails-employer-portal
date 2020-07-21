module EmployerPortal::EmployeeTag

  # ~~ public class methods ~~
  def self.whitelist(context)
    ::EmployerPortal::Query::EmployeeTag.new(
      context
    ).search_dataset({}, "").select_map :name
  end
end
