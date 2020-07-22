class EmployerPortal::EmployeeTag

  # ~~ public instance methods ~~
  def initialize(context)
    @context = context
  end

  def whitelist
    ::EmployerPortal::Query::EmployeeTag.new(
      context
    ).search_dataset({}, "").select_map :name
  end

  def find_or_create_tags(tags_before, tag_names)
    if context.allowed_all_employee_tags?
      tag_names.map do |tag_name|
        EmployeeTag.find_or_create(
          company_id: context.company_id,
          name: tag_name,
        )
      end
    else
      tags_before.reject do |tag|
        context.allowed_employee_tags.include? tag.id
      end + EmployeeTag.where(
        company_id: context.company_id,
        id: context.allowed_employee_tags,
        name: tag_names,
      ).all
    end
  end

  private

  attr_reader :context
end
