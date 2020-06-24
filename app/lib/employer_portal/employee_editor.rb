module EmployerPortal
  class EmployeeEditor

    # ~~ delegates ~~
    delegate :first_name, :last_name, :email, :phone, :state, :to_key,
      :to_model, to: :edited

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
  end
end
