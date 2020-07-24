class CompaniesController < ApplicationController
  # ~~ collection actions ~~
  def overrides
    return head :not_found unless params[:id].to_i == current_context.company_id

    respond_to do |format|
      format.css do
        expires_in 3.hours, public: true
        render plain: color_palette.css_overrides, content_type: "text/css"
      end
    end
  end

  def color_palette
    @color_palette ||= ::EmployerPortal::ColorPalette.new current_context.company
  end
end
