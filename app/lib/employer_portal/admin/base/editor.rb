class EmployerPortal::Admin::Base::Editor
  # ~~ delegates ~~
  delegate :to_key, :to_model, :to_param, to: :edited

  # ~~ public class methods ~~
  def self.from_params(context, params)
    edited = if params[:id].present?
        find_by_id!(params[:id])
      else
        new_model
      end
    new context, edited
  end

  # ~~ public instance methods ~~
  def initialize(context, edited)
    @context = context
    @edited = edited
  end

  def persisted?
    !edited.new?
  end

  def errors_on(column)
    edited.errors.on(column)
  end

  def update_attributes(attributes)
    edited.set attributes
    edited.save raise_on_failure: false
  end

  def destroy
    edited.update deleted_at: Time.now
  end

  protected

  def self.find_by_id!(_id)
    raise NotImplementedError
  end

  def self.new_model
    raise NotImplementedError
  end

  private

  attr_reader :context, :edited
end