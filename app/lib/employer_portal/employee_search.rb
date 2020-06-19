module EmployerPortal
  class EmployeeSearch
    include Pagy::Backend

    # ~~ accessors ~~
    attr_reader :results, :pagination

    # ~~ delegates ~~
    delegate :count, to: :pagination

    # ~~ public instance methods ~~
    def initialize(context, params)
      @context = context
      @params = params
      @pagination, @results = pagy(dataset)
    end

    def sort_order
      params[:order] || "fullname:asc"
    end

    private

    attr_reader :context, :params

    # ~~ overrides for Pagy ~~
    def pagy_get_vars(collection, vars)
      {
        count: collection.count,
        page: params["page"],
        items: vars[:items] || 2,
      }
    end

    # ~~ private instance methods ~~
    def dataset
      remote_db_name = ::EmployerPortal::RemoteDb.db_name
      ds = Employee.left_join(
        Sequel[remote_db_name][:employer_portal_employees],
        Sequel[remote_db_name][:employer_portal_employees][:email] => Sequel[:employees][:email]
      ).where(
        # should depend on company_id instead
        Sequel[:employees][:employer_id] => context.account_id
      ).select(
        Sequel.function(:coalesce,
          Sequel[remote_db_name][:employer_portal_employees][:email],
          Sequel[:employees][:email]
        ).as(:email),
        Sequel.function(:coalesce,
          Sequel[remote_db_name][:employer_portal_employees][:full_name],
          Sequel.function(:concat, Sequel[:employees][:first_name], " ", Sequel[:employees][:last_name])
        ).as(:full_name),
        Sequel[remote_db_name][:employer_portal_employees][:selfie_s3_key],
        Sequel.function(:coalesce,
          Sequel[remote_db_name][:employer_portal_employees][:state],
          Sequel[:employees][:state]
        ).as(:state),
        Sequel.function(:coalesce,
          Sequel[remote_db_name][:employer_portal_employees][:daily_checkup_status],
          "Did Not Submit"
        ).as(:daily_checkup_status),
        Sequel[remote_db_name][:employer_portal_employees][:daily_checkup_updated_at],
        Sequel.function(:coalesce,
          Sequel[remote_db_name][:employer_portal_employees][:daily_checkup_action],
          "Send Reminder"
        ).as(:daily_checkup_action),
        Sequel.function(:coalesce,
          Sequel[remote_db_name][:employer_portal_employees][:testing_status],
          "Not Registered"
        ).as(:testing_status),
        Sequel[remote_db_name][:employer_portal_employees][:testing_updated_at]
      ).union(
        Employee.right_outer_join(
          Sequel[remote_db_name][:employer_portal_employees],
          Sequel[remote_db_name][:employer_portal_employees][:email] => Sequel[:employees][:email]
        ).where(
          Sequel[:employees][:email] => nil
          # TODO: should use something like this:
          # Sequel[remote_db_name][:employer_portal_employees][:partner_id] => context.partner_id
        ).select(
          Sequel[remote_db_name][:employer_portal_employees][:email],
          Sequel[remote_db_name][:employer_portal_employees][:full_name],
          Sequel[remote_db_name][:employer_portal_employees][:selfie_s3_key],
          Sequel[remote_db_name][:employer_portal_employees][:state],
          Sequel[remote_db_name][:employer_portal_employees][:daily_checkup_status],
          Sequel[remote_db_name][:employer_portal_employees][:daily_checkup_updated_at],
          Sequel[remote_db_name][:employer_portal_employees][:daily_checkup_action],
          Sequel[remote_db_name][:employer_portal_employees][:testing_status],
          Sequel[remote_db_name][:employer_portal_employees][:testing_updated_at]
        ),
        all: true
      )
    end
  end
end
