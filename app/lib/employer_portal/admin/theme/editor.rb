class EmployerPortal::Admin::Theme::Editor < ::EmployerPortal::Admin::Base::Editor

  # ~~ delegates ~~
  delegate :name, to: :edited, prefix: :company

  # ~~ overrides for EmployerPortal::Admin::Base::Editor ~~
  def self.from_params(context, params)
    edited = find_by_id! params[:company_id]
    new context, edited
  end

  # ~~ public instance methods ~~
  def reset_attributes!
    edited.set color_overrides: {}
    edited.save
  end

  def update_attributes(params)
    theme_params = params.fetch :theme, {}
    edited.color_overrides = theme_params.fetch(:colors, {}).to_unsafe_h.select do |color, value|
      color_palette.used_colors.include?(color) && value != color_palette.default_value(color)
    end
    edited.save raise_on_failure: false
  end

  def color_palette
    @color_palette ||= ::EmployerPortal::ColorPalette.new edited
  end

  protected

  # ~~ overrides for EmployerPortal::Admin::Base::Editor ~~
  def self.find_by_id!(id)
    Company.where(
      id: id,
    ).limit(1).first || raise(::EmployerPortal::Error::Company::NotFound)
  end
end
