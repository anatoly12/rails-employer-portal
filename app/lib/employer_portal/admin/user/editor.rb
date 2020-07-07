class EmployerPortal::Admin::User::Editor < ::EmployerPortal::Admin::Base::Editor

  # ~~ delegates ~~
  delegate :email, to: :edited

  # ~~ public instance methods ~~
  def update_attributes(params)
    super params.fetch(:admin_user, {}).permit(
      :email,
      :password
    )
  end

  def myself?
    edited == context.account
  end

  def destroy
    edited.delete
  end

  protected

  # ~~ overrides for EmployerPortal::Admin::Base::Editor ~~
  def self.find_by_id!(id)
    AdminUser.where(
      id: id,
    ).limit(1).first || raise(::EmployerPortal::Error::AdminUser::NotFound)
  end

  def self.new_model
    AdminUser.new
  end
end
