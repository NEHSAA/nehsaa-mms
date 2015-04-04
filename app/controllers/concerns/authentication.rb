module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :user_signed_in?, :current_user, :current_user_session
  end

  def user_signed_in?
    !!current_user_session
  end

  def current_user_session
    if not defined?(@current_user_session)
      @current_user_session = UserSession.find
    end
    @current_user_session
  end

  def current_user
    if not defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end
    @current_user
  end

  def authenticate_user!
    unless user_signed_in?
      flash[:alert] = 'Login is required'
      redirect_to controller: 'user_session', action: 'new'
    end
  end

end
