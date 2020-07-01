class EmailLog < Sequel::Model
  # ~~ plugins ~~
  plugin :timestamps, update: false
  plugin :active_model

  # ~~ associations ~~
  many_to_one :email_template, class: "Employer"
  many_to_one :company, class: "Company"
  many_to_one :employer, class: "Employer"
  many_to_one :employee, class: "Employee"
end
