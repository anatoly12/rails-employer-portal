module EmployerPortal
  class SymptomLogViewer

    # ~~ public instance methods ~~
    def initialize(context, params)
      @context = context
      @params = params
    end

    def employee_editor
      @employee_editor ||= ::EmployerPortal::EmployeeEditor.new context, employee
    end

    private

    attr_reader :context, :params, :symptom_log_params

    # ~~ private instance methods ~~
    def employee
      @employee ||= Employee.where(
        employer_id: context.account_id,
        uuid: params[:employee_id],
      ).limit(1).first || raise(::EmployerPortal::Error::Employee::NotFound)
    end
  end
end
