class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include Authentication
  include Authorization
  include ResponseStatus

  rescue_from UnauthorizedActionError, with: :render_forbidden_status

end
