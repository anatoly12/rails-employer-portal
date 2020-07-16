class EmployerPortal::Admin::Plan::Editor < ::EmployerPortal::Admin::Base::Editor

  # ~~ delegates ~~
  delegate :name, :daily_checkup_enabled, :testing_enabled,
    :health_passport_enabled, :employer_limit, :employee_limit, :remote_id,
    to: :edited

  # ~~ public instance methods ~~
  def update_attributes(params)
    super params.fetch(:plan, {}).permit(
      :name,
      :daily_checkup_enabled,
      :testing_enabled,
      :health_passport_enabled,
      :employer_limit,
      :employee_limit,
      :remote_id
    )
  end

  def remote_ids_for_select
    ::EmployerPortal::Sync::PassportProduct.order(
      :passport_product_id
    ).all.map do |passport|
      [passport.name, passport.pk]
    end
  end

  protected

  # ~~ overrides for EmployerPortal::Admin::Base::Editor ~~
  def self.find_by_id!(id)
    Plan.where(
      id: id,
    ).limit(1).first || raise(::EmployerPortal::Error::Plan::NotFound)
  end

  def self.new_model
    Plan.new
  end
end
