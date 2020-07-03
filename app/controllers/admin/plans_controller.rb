class Admin::PlansController < Admin::BaseController
  rescue_from ::EmployerPortal::Error::Plan::NotFound, with: :plan_not_found

  # ~~ collection actions ~~
  def index
  end

  def new
  end

  def create
    if editor.update_attributes params
      flash.notice = "Plan was created successfully."
      redirect_to action: :index
    else
      flash.now.alert = "Please review errors and try submitting it again."
      render :new
    end
  end

  # ~~ member actions ~~
  def show
    redirect_to action: :edit
  end

  def edit
  end

  def update
    if editor.update_attributes params
      flash.notice = "Plan was updated successfully."
      redirect_to action: :index
    else
      flash.now.alert = "Please review errors and try submitting it again."
      render :edit
    end
  end

  def destroy
    editor.destroy
    flash.notice = "Plan was deleted successfully."
    redirect_to action: :index
  end

  private

  def plan_not_found
    flash.alert = "Plan not found."
    redirect_to action: :index
  end

  def search
    @search ||= ::EmployerPortal::Admin::Plan::Search.new current_context, params
  end

  helper_method :search

  def editor
    @editor ||= ::EmployerPortal::Admin::Plan::Editor.from_params current_context, params
  end

  helper_method :editor
end
