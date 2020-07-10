module RequestHelpers
  def sign_in_as_employer(employer = nil)
    employer ||= create :employer
    post "/sign-in", params: { session: { username: employer.email, password: employer.password } }
  end
end
