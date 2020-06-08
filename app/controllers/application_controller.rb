class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: "ecp", password: "ecp"
end
