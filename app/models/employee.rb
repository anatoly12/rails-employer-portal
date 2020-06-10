class Employee < Sequel::Model

  # ~~ plugins ~~
  plugin :uuid
  plugin :timestamps, update_on_create: true
  plugin :validation_helpers

  # ~~ validations ~~
  def validate
    super
    validates_presence [:first_name, :last_name, :email, :phone]
    validates_format /\A[^@\s]+@[^@\s]+\z/, :email
    validates_unique [:company_id, :email], message: Sequel.lit("email is already taken")
    if zipcode.present?
      validate_zipcode
    else
      validates_presence :state
      validates_inclusion UsaState.state_codes, :state
    end
  end

  # ~~ associations ~~
  many_to_one :company, class: "Company"
  many_to_one :employer, class: "Employer"
  one_to_many :employees, class: "Employee"

private

  # ~~ private instance methods ~~
  def validate_zipcode
    zip = ZipCode.where(zip: zipcode).limit(1).first
    if zip
      set state: zip.state
    else
      errors.add(:zipcode, "must be a valid ZIP Code")
    end
  end
end
