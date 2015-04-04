crumb :members do
  link I18n.t("ui.members.index"), members_path
end

crumb :member do |member|
  link member.name, member_path(member)
  parent :members
end

crumb :edit_member do |member|
  link I18n.t("ui.members.edit"), edit_member_path(member)
  parent :member, member
end

crumb :new_member do
  link I18n.t("ui.members.new"), new_member_path
  parent :members
end

crumb :memberships do |member|
  link Membership.model_name.human, member_memberships_path
  parent :member, member
end

crumb :members_moi_sheet do
  link I18n.t("ui.members.moi_sheet"), {controller: :members, action: :moi_sheet}
  parent :members
end

crumb :members_email_list do
  link I18n.t("ui.members.email_list"), {controller: :members, action: :email_list}
  parent :members
end

crumb :members_importer do
  link I18n.t("ui.members.import"), {controller: :members_import, action: :index}
  parent :members
end
