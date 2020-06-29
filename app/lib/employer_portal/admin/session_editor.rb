class EmployerPortal::Admin::SessionEditor < ::EmployerPortal::SessionEditor
  private

  # ~~ private instance methods ~~
  def account
    @account ||= AdminUser.where(email: username).limit(1).first
  end
end
