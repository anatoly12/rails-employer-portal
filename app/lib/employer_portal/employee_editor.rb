module EmployerPortal
  class EmployeeEditor

    # ~~ delegates ~~
    delegate :first_name, :last_name, :email, :phone, :state, :to_key,
      :to_model, :to_param, to: :edited

    # ~~ public class methods ~~
    def self.from_params(context, params)
      edited = if params[:id].present?
          Employee.where(
            company_id: context.company_id,
            uuid: params[:id],
          ).limit(1).first || raise(::EmployerPortal::Error::Employee::NotFound)
        else
          Employee.new(
            company_id: context.company_id,
            employer_id: context.account_id,
          )
        end
      new context, edited, params.permit(:filters, :order, :page)
    end

    # ~~ public instance methods ~~
    def initialize(context, edited, symptom_log_params = {})
      @context = context
      @edited = edited
      @symptom_log_params = symptom_log_params
    end

    def persisted?
      !edited.new?
    end

    def errors_on(column)
      edited.errors.on(column)
    end

    def update_attributes(params)
      edited.set params.fetch(:employee, {}).permit(
        :first_name,
        :last_name,
        :email,
        :phone,
        :state
      )
      success = edited.save raise_on_failure: false
      CreateAccountForEmployeeJob.perform_later edited.uuid if success
      success
    end

    def symptom_log_search
      @symptom_log_search ||= ::EmployerPortal::SymptomLogSearch.new context, edited, symptom_log_params
    end

    def testing_status
      dashboard_employee&.testing_status || "Not Registered"
    end

    private

    attr_reader :context, :edited, :symptom_log_params

    # ~~ private instance methods ~~
    def dashboard_employee
      edited.dashboard_employee if persisted? && context.sync_connected?
    end
  end
end
