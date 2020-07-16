RSpec::Matchers.define :require_authentication do |method, url, params = {}|
  match do
    public_send method, url, params: params
    redirect_params = { session: { return_path: url } }.to_param
    expect(response).to redirect_to "/sign-in?#{redirect_params}"
    expect(flash[:alert]).to be_nil
    expect(flash[:notice]).to be_nil
  end
  description { "require authentication" }
end

RSpec::Matchers.define :require_admin_authentication do |method, url, params = {}|
  match do
    public_send method, url, params: params
    expect(response).to redirect_to "/admin/sign-in"
    expect(flash[:alert]).to be_nil
    expect(flash[:notice]).to be_nil
  end
  description { "require admin authentication" }
end

RSpec::Matchers.define :render_successfully do |method, url, params = {}|
  match do
    public_send method, url, params: params
    expect(response).to have_http_status :success
  end
  description { "render successfully" }
end
