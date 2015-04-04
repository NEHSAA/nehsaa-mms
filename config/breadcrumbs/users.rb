crumb :users do
  link I18n.t("ui.users.index"), users_path
end

crumb :user do |user|
  link user.login, user_path(user)
  parent :users
end

crumb :edit_user do |user|
  link I18n.t("ui.users.edit"), edit_user_path(user)
  parent :user, user
end

crumb :new_user do
  link I18n.t("ui.users.new"), new_user_path
  parent :users
end
