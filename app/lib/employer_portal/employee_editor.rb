module EmployerPortal
  class EmployeeEditor

    # ~~ delegates ~~
    delegate :first_name, :last_name, :email, :phone, :state, :to_key,
      :to_model, :to_param, to: :edited

    # ~~ public instance methods ~~
    def initialize(context, params)
      @context = context
      @params = params
    end

    def persisted?
      !edited.new?
    end

    def errors_on(column)
      edited.errors.on(column)
    end

    def update_attributes(params)
      edited.set params.fetch(:employee, {}).permit(:first_name, :last_name, :email, :phone, :state)
      edited.save raise_on_failure: false
      CreateAccountForEmployeeJob.perform_later edited.uuid
    end

    def symptom_log_search
      @symptom_log_search ||= ::EmployerPortal::SymptomLogSearch.new context, edited, params
    end

    def testing_status
      dashboard_employee&.testing_status || "Not Registered"
    end

    private

    attr_reader :context, :params, :symptom_log_params

    # ~~ private instance methods ~~
    def given_id
      params[:id]
    end

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

    def connected?
      ::EmployerPortal::Sync.connected?
    end

    def dashboard_employee
      edited.dashboard_employee if persisted? && connected?
    end
  end
end
