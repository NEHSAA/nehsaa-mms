module ApplicationHelper

  def user_session_link
    if user_signed_in?
      link_to I18n.t("ui.user_session.logout"),
              { controller: 'user_session',
                action: 'destroy',
                only_path: true },
              { method: :delete }
    else
      link_to I18n.t("ui.user_session.login"),
              { controller: 'user_session',
                action: 'new',
                only_path: true }
    end
  end

end
