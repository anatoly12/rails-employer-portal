module AdminHelper

  # ~~ public methods ~~
  def gravatar
    md5 = Digest::MD5.hexdigest(current_context.email.to_s.downcase)
    "https://www.gravatar.com/avatar/#{md5}?d=wavatar&r=pg"
  end

  def label_class
    "block text-gray-700 text-sm font-bold mb-2 select-none"
  end

  def current_controller?(options)
    url_string = CGI.escapeHTML(url_for(options))
    params = Rails.application.routes.recognize_path(url_string, :method => :get)
    params[:controller] == controller_path
  end

end
