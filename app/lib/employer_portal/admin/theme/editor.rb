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
    edited.set logo_s3_key: nil, color_overrides: {}
    edited.save
  end

  def update_attributes(params)
    theme_params = params.fetch :theme, {}
    logo = theme_params[:logo]
    if logo&.size.to_i > 0
      edited.logo_s3_key = ::EmployerPortal::Aws.upload_file(
        logo.path,
        "companies/#{edited.uuid}/#{SecureRandom.uuid}#{File.extname logo.path}"
      )
    end
    edited.color_overrides = theme_params.fetch(:colors, {}).to_unsafe_h.select do |color, value|
      color_palette.used_colors.include?(color) && value != color_palette.default_value(color)
    end
    edited.save raise_on_failure: false
  end

  def color_palette
    @color_palette ||= ::EmployerPortal::ColorPalette.new edited
  end

  def logo_url
    ::EmployerPortal::Aws.presigned_url edited.logo_s3_key
  end

  def can_reset?
    edited.color_overrides.present? || logo_url.present?
  end

  protected

  # ~~ overrides for EmployerPortal::Admin::Base::Editor ~~
  def self.find_by_id!(id)
    Company.where(
      id: id,
    ).limit(1).first || raise(::EmployerPortal::Error::Company::NotFound)
  end
end
