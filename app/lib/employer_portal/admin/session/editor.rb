class EmployerPortal::Admin::Session::Editor < ::EmployerPortal::Session::Editor
  private

  # ~~ private instance methods ~~
  def account
    @account ||= AdminUser.where(email: username).limit(1).first
  end
end
