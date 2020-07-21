class EmployeeTag < Sequel::Model

  # ~~ plugins ~~
  plugin :timestamps, update_on_create: true
  plugin :validation_helpers

  # ~~ validations ~~
  def validate
    super
    validates_presence [:company_id, :name]
    validates_unique(:name) { |ds| ds.where(company_id: company_id) }
  end

  # ~~ associations ~~
  many_to_one :company, class: "Company"
  one_to_many :taggings, class: "EmployeeTagging"

  # ~~ public instance methods ~~
  def for_select
    [name, id]
  end
end
