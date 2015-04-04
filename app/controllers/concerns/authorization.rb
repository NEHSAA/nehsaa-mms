module Authorization
  extend ActiveSupport::Concern

  def authorize_super_user!
    unless current_user.super
      raise UnauthorizedActionError, "Must be a super user"
    end
  end

end
