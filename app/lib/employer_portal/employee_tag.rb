class EmployerPortal::EmployeeTag

  # ~~ public instance methods ~~
  def initialize(context)
    @context = context
  end

  def for_select
    options = ::EmployerPortal::Query::EmployeeTag.new(
      context
    ).search_dataset({}, "").all.map(&:for_select)
    if context.allowed_all_employee_tags?
      options if options.present?
    else
      options if options.size > 1
    end
  end

  def whitelist
    ::EmployerPortal::Query::EmployeeTag.new(
      context
    ).search_dataset({}, "").select_map :name
  end

  def find_or_create_tags(tags_before, tag_names)
    if context.allowed_to_add_employee_tags?
      tag_names.map { |tag_name| EmployeeTag.find_or_create company_id: context.company_id, name: tag_name }
    elsif context.allowed_all_employee_tags?
      EmployeeTag.where(company_id: context.company_id, name: tag_names).all
    else
      tags_before.reject do |tag|
        context.allowed_employee_tags.include? tag.id
      end + EmployeeTag.where(id: context.allowed_employee_tags, name: tag_names).all
    end
  end

  private

  attr_reader :context
end
