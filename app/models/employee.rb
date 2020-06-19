require "uri"

class Employee < Sequel::Model
  # ~~ plugins ~~
  plugin :uuid
  plugin :timestamps, update_on_create: true
  plugin :validation_helpers
  plugin :active_model

  # ~~ validations ~~
  def validate
    super
    validates_presence [:first_name, :last_name, :email, :phone]
    validates_format ::EmployerPortal::Regexp::EMAIL_FORMAT, :email, allow_blank: true
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

  # ~~~ public instance methods ~~~
  def to_param
    URI.encode_www_form_component(email)
  end

  def full_name
    values.fetch(:full_name, "#{first_name} #{last_name}")
  end

  def profile_picture_url
    # TODO: do something with values[:selfie_s3_key]
  end

  def daily_checkup_status
    values.fetch(:daily_checkup_status, "Did Not Submit")
  end

  def daily_checkup_updated_at
    values.fetch(:daily_checkup_updated_at, "Never")
  end

  def daily_checkup_action
    values.fetch(:daily_checkup_action, "Send Reminder")
  end

  def testing_status
    values.fetch(:testing_status, "Not Registered")
  end

  def testing_updated_at
    values.fetch(:testing_updated_at, "Never")
  end

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
