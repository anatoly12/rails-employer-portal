module EmployerPortal
  class SymptomLogViewer
    # ~~ public class methods ~~
    def self.from_params(context, params)
      employee = Employee.where(
        company_id: context.company_id,
        uuid: params[:employee_id],
      ).limit(1).first || raise(::EmployerPortal::Error::Employee::NotFound)
      date = params[:id]
      new context, employee, date
    end

    # ~~ accessors ~~
    attr_reader :employee, :date

    # ~~ public instance methods ~~
    def initialize(context, employee, date)
      @context = context
      @employee = employee
      @date = date
    end

    def employee_editor
      @employee_editor ||= ::EmployerPortal::EmployeeEditor.new context, employee
    end

    def entries
      return [] unless context.sync_connected?

      @entries ||= SymptomLogEntry.where(
        account_id: employee.remote_id,
        log_date: date
      ).order(:id).all.map do |entry|
        ::EmployerPortal::SymptomLogEntryViewer.new context, entry
      end.select(&:visible?)
    end

    private

    attr_reader :context
  end
end
