class Employee < Sequel::Model

  # ~~ plugins ~~
  plugin :uuid
  plugin :timestamps, update_on_create: true
  plugin :validation_helpers

  # ~~ validations ~~
  def validate
    super
    validates_presence [:first_name, :last_name, :email, :phone]
    validates_format EmployerPortal::Regexp::EMAIL_FORMAT, :email, allow_blank: true
    validates_unique(:email) { |ds| ds.where(company_id: company_id) }
    if zipcode.present?
      validate_zipcode
    else
      validates_presence :state
      validates_includes UsaState.state_codes, :state, allow_blank: true, message: "must be a valid state code"
    end
  end

  # ~~ associations ~~
  many_to_one :company, class: "Company"
  many_to_one :employer, class: "Employer"
  one_to_many :employees, class: "Employee"

  private

  # ~~ private instance methods ~~
  def validate_zipcode
    zip = ZipCode[zipcode]
    if zip
      set state: zip.state
    else
      errors.add(:zipcode, "must be a valid ZIP Code")
    end
  end
end