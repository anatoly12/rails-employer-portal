RSpec::Matchers.define :require_authentication do |method, url, params = {}|
  match do
    public_send method, url, params: params
    redirect_params = { session: { return_path: url } }.to_param
    expect(response).to redirect_to "/sign-in?#{redirect_params}"
    follow_redirect!
    expect(response).to have_http_status :success
  end
  description { "require authentication" }
end

RSpec::Matchers.define :render_successfully do |method, url, params = {}|
  match do
    public_send method, url, params: params
    expect(response).to have_http_status :success
  end
  description { "render successfully" }
end
