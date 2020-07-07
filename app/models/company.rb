class Company < Sequel::Model

  # ~~ plugins ~~
  plugin :uuid
  plugin :timestamps, update_on_create: true
  plugin :validation_helpers
  plugin :active_model

  # ~~ validations ~~
  def validate
    super
    validates_presence [:name, :plan_id]
    validates_presence :remote_id unless new?
    validates_integer :remote_id, allow_blank: true
  end

  # ~~ associations ~~
  many_to_one :plan, class: "Plan"
  one_to_many :employers, class: "Employer"
  one_to_many :undeleted_employers, class: "Employer" do |ds|
    employers_dataset.where deleted_at: nil
  end
  one_to_many :employees, class: "Employee"
end
