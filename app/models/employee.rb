class Employee < Sequel::Model

  # ~~ validations ~~
  plugin :validation_helpers
  def validate
    super
    validates_presence [:first_name, :last_name, :email, :phone]
    if zipcode.present?
      validate_zipcode
    else
      validates_presence :state
      validates_inclusion UsaState.state_codes, :state
    end
  end

  # ~~ plugins ~~
  plugin :uuid
  plugin :timestamps

  # ~~ associations ~~
  many_to_one :employer, class: "Employer"
  one_to_many :employees, class: "Employee"

private

  # ~~ private instance methods ~~
  def validate_zipcode
    zip = ZipCode.where(zip: zipcode).limit(1).first
    if zip
      state = zip.state
    else
      errors.add(:zipcode, "must be a valid ZIP Code")
    end
  end
end
