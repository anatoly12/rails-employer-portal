module Sequel::Plugins::WithAudits

  # ~~ constants ~~
  THREAD_CREATED_BY_TYPE = :sequel_plugins_with_audits_created_by_type
  THREAD_CREATED_BY_ID = :sequel_plugins_with_audits_created_by_id

  # ~~ plugin interface ~~
  def self.apply(model, opts = {})
    model.instance_eval do
      plugin :polymorphic
      plugin :dirty
    end
  end

  def self.configure(model, opts = {})
    model.instance_eval do
      @audit_ignored_columns = opts.fetch(:except, [])
      @audit_ignored_columns << :id
      @audit_ignored_columns << :created_at
      @audit_ignored_columns << :updated_at

      one_to_many :audits, as: :item
    end
  end

  # ~~ public class methods ~~
  def self.audited_by(user)
    if user.kind_of? ::EmployerPortal::Context::NoAccount
      Thread.current[THREAD_CREATED_BY_TYPE] = nil
      Thread.current[THREAD_CREATED_BY_ID] = nil
    else
      Thread.current[THREAD_CREATED_BY_TYPE] = user.model
      Thread.current[THREAD_CREATED_BY_ID] = user.pk
    end
  end

  def self.created_by_type
    Thread.current[THREAD_CREATED_BY_TYPE]
  end

  def self.created_by_id
    Thread.current[THREAD_CREATED_BY_ID]
  end

  module ClassMethods
    attr_reader :audit_ignored_columns

    Sequel::Plugins.inherited_instance_variables self, :@audit_ignored_columns => nil
  end

  module InstanceMethods
    def changes_for_event(event)
      if event == "update"
        previous_changes
      else
        values
      end.select do |key, value|
        !self.class.audit_ignored_columns.include?(key) && !value.nil?
      end
    end

    def add_audited(event)
      changes = changes_for_event event

      Audit.create(
        item_type: model,
        item_id: pk,
        event: event,
        changes: changes.to_json,
        created_by_type: Sequel::Plugins::WithAudits.created_by_type,
        created_by_id: Sequel::Plugins::WithAudits.created_by_id,
      ) if changes.present?
    end

    # ~~ callbacks ~~
    def after_create
      super
      add_audited("create")
    end

    def after_update
      super
      add_audited("update")
    end

    def after_destroy
      super
      add_audited("destroy")
    end
  end
end
