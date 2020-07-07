class EmployerPortal::Admin::User::Viewer < ::EmployerPortal::Admin::Base::Viewer
  # ~~ delegates ~~
  delegate :email, :created_at, to: :decorated

  # ~~ public instance methods ~~
  def myself?
    decorated == context.account
  end
end
