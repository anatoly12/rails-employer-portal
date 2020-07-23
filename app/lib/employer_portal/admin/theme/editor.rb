class EmployerPortal::Admin::Theme::Editor < ::EmployerPortal::Admin::Base::Editor

  # ~~ delegates ~~
  delegate :name, to: :edited, prefix: :company
  delegate :used_colors, to: :color_palette

  # ~~ overrides for EmployerPortal::Admin::Base::Editor ~~
  def from_params(context, params)
    edited = find_by_id! params[:company_id]
    new context, edited
  end

  # ~~ public instance methods ~~
  def update_attributes(params)
    success = super params.fetch(:company, {}).permit(:name, :plan_id, :remote_id)
    CreatePartnerForCompanyJob.perform_later edited.uuid if success
    success
  end

  protected

  # ~~ overrides for EmployerPortal::Admin::Base::Editor ~~
  def self.find_by_id!(id)
    Company.where(
      id: id,
    ).limit(1).first || raise(::EmployerPortal::Error::Company::NotFound)
  end

  def color_palette
    @color_palette ||= ::EmployerPortal::ColorPalette.new
    # raise @color_palette.used_colors.inspect
  end

  def self.new_model
    Company.new
  end
end
