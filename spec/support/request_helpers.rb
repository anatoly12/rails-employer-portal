module RequestHelpers
  def sign_in_as_employer(employer = nil)
    employer ||= create :employer
    post "/sign-in", params: { session: { username: employer.email, password: employer.password } }
  end

  def sign_in_as_admin_user(admin_user = nil)
    admin_user ||= create :admin_user
    post "/admin/sign-in", params: { session: { username: admin_user.email, password: admin_user.password } }
  end
end
