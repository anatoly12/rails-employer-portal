class EmployeeTagging < Sequel::Model

  # ~~ plugins ~~
  plugin :timestamps, update: false

  # ~~ associations ~~
  many_to_one :employee, class: "Employee"
  many_to_one :tag, class: "EmployeeTag", key: :employee_tag_id
end
