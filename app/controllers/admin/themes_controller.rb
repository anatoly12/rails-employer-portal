class Admin::ThemesController < Admin::BaseController
  rescue_from ::EmployerPortal::Error::Company::NotFound, with: :company_not_found

  # ~~ member actions ~~
  def show
  end

  def update
    if editor.update_attributes params
      flash.notice = "Theme for #{editor.company_name} was updated successfully."
      redirect_to admin_companies_path
    else
      flash.now.alert = "Please review errors and try submitting it again."
      render :show
    end
  end

  def destroy
    editor.reset_attributes!
    flash.notice = "Theme for #{editor.company_name} was reset successfully."
    render :show
  end

  private

  def company_not_found
    flash.alert = "Company not found."
    redirect_to admin_companies_path
  end

  def editor
    @editor ||= ::EmployerPortal::Admin::Theme::Editor.from_params current_context, params
  end

  helper_method :editor
end
