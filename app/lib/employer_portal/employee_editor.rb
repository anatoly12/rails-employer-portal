module EmployerPortal
  class EmployeeEditor

    # ~~ delegates ~~
    delegate :first_name, :last_name, :email, :phone, :state, :to_key,
      :to_model, to: :edited
    delegate :daily_checkup_status, :testing_status, to: :dashboard_employee

    # ~~ public instance methods ~~
    def initialize(context, id)
      @context = context
      @given_id = id
    end

    def persisted?
      !edited.new?
    end

    def errors_on(column)
      edited.errors.on(column)
    end

    def update_attributes(params)
      edited.set params
      edited.save raise_on_failure: false
      CreateAccountForEmployeeJob.perform_later edited.uuid
    end

    private

    attr_reader :context, :given_id

    # ~~ private instance methods ~~
    def edited
      @edited ||= if given_id.present?
          Employee.where(
            employer_id: context.account_id,
            uuid: given_id,
          ).limit(1).first || raise(::EmployerPortal::Error::Employee::NotFound)
        else
          Employee.new(
            company_id: context.company_id,
            employer_id: context.account_id,
          )
        end
    end

    def dashboard_employee
      return edited unless persisted? && ::EmployerPortal::Sync.connected?

      @dashboard_employee ||= Employee.left_join(
        :dashboard_employees,
        id: Sequel.qualify(:employees, :remote_id)
      ).where(
        Sequel.qualify(:employees, :id) => edited.id
      ).select(
        Sequel.qualify(:dashboard_employees, :full_name),
        Sequel.qualify(:dashboard_employees, :selfie_s3_key),
        Sequel.qualify(:dashboard_employees, :state),
        Sequel.qualify(:dashboard_employees, :daily_checkup_status),
        Sequel.qualify(:dashboard_employees, :daily_checkup_updated_at),
        Sequel.qualify(:dashboard_employees, :daily_checkup_action),
        Sequel.qualify(:dashboard_employees, :testing_status),
        Sequel.qualify(:dashboard_employees, :testing_updated_at),
      ).limit(1).first
    end
  end
end
