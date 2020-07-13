class EmployerPortal::Sync::Legacy

  # ~~ public instance methods ~~
  def initialize(schema, klass)
    @schema = schema
    @klass = klass
  end

  def define_models
    klass.const_set :AccessCode, access_code_class
    klass.const_set :AccessGrant, access_grant_class
    klass.const_set :Account, account_class
    klass.const_set :Covid19DailyCheckup, covid19_daily_checkup_class
    klass.const_set :Covid19DailyCheckupStatus, covid19_daily_checkup_status_class
    klass.const_set :Covid19Evaluation, covid19_evaluation_class
    klass.const_set :Covid19Message, covid19_message_class
    klass.const_set :Covid19MessageCode, covid19_message_code_class
    klass.const_set :DataType, data_type_class
    klass.const_set :Demographic, demographic_class
    klass.const_set :Kit, kit_class
    klass.const_set :List, list_class
    klass.const_set :ListItem, list_item_class
    klass.const_set :Partner, partner_class
    klass.const_set :PassportProduct, passport_product_class
    klass.const_set :Question, question_class
    klass.const_set :Requisition, requisition_class
    klass.const_set :TKit, t_kit_class
    klass.const_set :TQuestion, t_question_class
    klass.const_set :User, user_class
  end

  def undefine_models
    klass.send :remove_const, :AccessCode
    klass.send :remove_const, :AccessGrant
    klass.send :remove_const, :Account
    klass.send :remove_const, :Covid19DailyCheckup
    klass.send :remove_const, :Covid19DailyCheckupStatus
    klass.send :remove_const, :Covid19Evaluation
    klass.send :remove_const, :Covid19Message
    klass.send :remove_const, :Covid19MessageCode
    klass.send :remove_const, :DataType
    klass.send :remove_const, :Demographic
    klass.send :remove_const, :Kit
    klass.send :remove_const, :List
    klass.send :remove_const, :ListItem
    klass.send :remove_const, :Partner
    klass.send :remove_const, :PassportProduct
    klass.send :remove_const, :Question
    klass.send :remove_const, :Requisition
    klass.send :remove_const, :TKit
    klass.send :remove_const, :TQuestion
    klass.send :remove_const, :User
  end

  private

  attr_reader :schema, :klass

  # ~~ private instance methods ~~
  def db
    Sequel::Model.db
  end

  def access_code_class
    prefix = klass.to_s
    Class.new(
      Sequel::Model(db[schema[:partner_access_codes]])
    ) {
      many_to_one :partner, class: "#{prefix}::Partner"
      plugin :timestamps, update_on_create: true
    }
  end

  def access_grant_class
    prefix = klass.to_s
    Class.new(
      Sequel::Model(db[schema[:account_access_grants]])
    ) {
      many_to_one :account, class: "#{prefix}::Account"
      many_to_one :access_code, class: "#{prefix}::AccessCode", key: :partner_access_code_id
      plugin :timestamps, update_on_create: true
    }
  end

  def account_class
    prefix = klass.to_s
    Class.new(
      Sequel::Model(db[schema[:accounts]])
    ) {
      many_to_one :user, class: "#{prefix}::User"
      one_to_one :demographic, class: "#{prefix}::Demographic", key: :account_id
      one_to_many :access_grants, class: "#{prefix}::AccessGrant", key: :account_id
      one_to_many :covid19_daily_checkups, class: "#{prefix}::Covid19DailyCheckup", key: :account_id
      one_to_many :covid19_evaluations, class: "#{prefix}::Covid19Evaluation", key: :account_id
      one_to_many :covid19_messages, class: "#{prefix}::Covid19Message", key: :account_id
      plugin :timestamps, update_on_create: true
    }
  end

  def covid19_daily_checkup_class
    prefix = klass.to_s
    Class.new(
      Sequel::Model(db[schema[:covid19_daily_checkups]])
    ) {
      unrestrict_primary_key
      many_to_one :account, class: "#{prefix}::Account"
      many_to_one :status, class: "#{prefix}::Covid19DailyCheckupStatus", key: :covid19_daily_status_code
      plugin :timestamps, update_on_create: true
    }
  end

  def covid19_daily_checkup_status_class
    prefix = klass.to_s
    Class.new(
      Sequel::Model(db[schema[:covid19_daily_checkup_statuses]])
    ) {
      unrestrict_primary_key
      plugin :timestamps, update_on_create: true
    }
  end

  def covid19_evaluation_class
    prefix = klass.to_s
    Class.new(
      Sequel::Model(db[schema[:covid19_evaluations]])
    ) {
      many_to_one :account, class: "#{prefix}::Account"
      plugin :timestamps, update_on_create: true
    }
  end

  def covid19_message_class
    prefix = klass.to_s
    Class.new(
      Sequel::Model(db[schema[:covid19_messages]])
    ) {
      many_to_one :account, class: "#{prefix}::Account"
      many_to_one :code, class: "#{prefix}::Covid19MessageCode", key: :message_code
      plugin :timestamps, update_on_create: true
    }
  end

  def covid19_message_code_class
    prefix = klass.to_s
    Class.new(
      Sequel::Model(db[schema[:covid19_message_codes]])
    ) {
      one_to_many :messages, class: "#{prefix}::Covid19Message", key: :message_code
      plugin :timestamps, update_on_create: true
    }
  end

  def data_type_class
    prefix = klass.to_s
    Class.new(
      Sequel::Model(db[schema[:ec_data_types]])
    ) {
      many_to_one :list, class: "#{prefix}::List"
      plugin :timestamps, update_on_create: true
    }
  end

  def demographic_class
    prefix = klass.to_s
    Class.new(
      Sequel::Model(db[schema[:account_demographics]])
    ) {
      many_to_one :account, class: "#{prefix}::Account"
      plugin :timestamps, update_on_create: true
    }
  end

  def kit_class
    prefix = klass.to_s
    Class.new(
      Sequel::Model(db[schema[:ec_kits]])
    ) {
      many_to_one :t_kit, class: "#{prefix}::TKit"
      many_to_one :partner, class: "#{prefix}::Partner"
      many_to_one :requisition, class: "#{prefix}::Requisition"
      plugin :timestamps, update_on_create: true
    }
  end

  def list_class
    prefix = klass.to_s
    Class.new(
      Sequel::Model(db[schema[:ec_lists]])
    ) {
      one_to_many :items, class: "#{prefix}::ListItem", key: :list_id
      plugin :timestamps, update_on_create: true
    }
  end

  def list_item_class
    prefix = klass.to_s
    Class.new(
      Sequel::Model(db[schema[:ec_list_items]])
    ) {
      unrestrict_primary_key
      many_to_one :list, class: "#{prefix}::List"
      plugin :timestamps, update_on_create: true
    }
  end

  def partner_class
    prefix = klass.to_s
    Class.new(
      Sequel::Model(db[schema[:ec_partners]])
    ) {
      many_to_one :passport_product, class: "#{prefix}::PassportProduct"
      one_to_many :access_codes, class: "#{prefix}::AccessCode", key: :partner_id
      plugin :timestamps, update_on_create: true
    }
  end

  def passport_product_class
    prefix = klass.to_s
    Class.new(
      Sequel::Model(db[schema[:passport_products]])
    ) {
      many_to_one :t_kit, class: "#{prefix}::TKit"
      plugin :timestamps, update_on_create: true
    }
  end

  def question_class
    prefix = klass.to_s
    Class.new(
      Sequel::Model(db[schema[:ec_questions]])
    ) {
      many_to_one :t_question, class: "#{prefix}::TQuestion"
      many_to_one :kit, class: "#{prefix}::Kit"
      many_to_one :data_type, class: "#{prefix}::DataType"
      plugin :timestamps, update_on_create: true
    }
  end

  def requisition_class
    prefix = klass.to_s
    Class.new(
      Sequel::Model(db[schema[:ec_requisitions]])
    ) {
      many_to_one :user, class: "#{prefix}::User"
      one_to_one :kit, class: "#{prefix}::Kit", key: :requisition_id
      plugin :timestamps, update_on_create: true
    }
  end

  def t_kit_class
    prefix = klass.to_s
    Class.new(
      Sequel::Model(db[schema[:ec_t_kits]])
    ) {
      plugin :timestamps, update_on_create: true
    }
  end

  def t_question_class
    prefix = klass.to_s
    Class.new(
      Sequel::Model(db[schema[:ec_t_questions]])
    ) {
      many_to_one :data_type, class: "#{prefix}::DataType"
      plugin :timestamps, update_on_create: true
    }
  end

  def user_class
    prefix = klass.to_s
    Class.new(
      Sequel::Model(db[schema[:ec_users]])
    ) {
      one_to_one :account, class: "#{prefix}::Account", key: :account_id
      one_to_many :requisitions, class: "#{prefix}::Requisition", key: :user_id
      plugin :timestamps, update_on_create: true
    }
  end
end
