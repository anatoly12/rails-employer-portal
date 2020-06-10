class Employee < Sequel::Model

  # ~~ validations ~~
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, format: { with: /\A[^@\s]+@[^@\s]+\z/ }
  validates :phone_number, presence: true
  validates :state, presence: true, inclusion: { in: UsaState.CODES }

  # ~~ plugins ~~
  plugin :uuid
  plugin :timestamps

  # ~~ associations ~~
  many_to_one :employer, class: "Employer"
  one_to_many :employees, class: "Employee"

end
