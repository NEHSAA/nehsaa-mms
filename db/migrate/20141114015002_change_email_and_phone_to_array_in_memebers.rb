class ChangeEmailAndPhoneToArrayInMemebers < ActiveRecord::Migration

  def up
    add_column :members, :emails, :string, null: false,
                                           array: true,
                                           default: []
    add_column :members, :phones, :string, null: false,
                                           array: true,
                                           default: []

    Member.find_each do |member|
      member.emails = member.email.split(';').map(&:strip)
      member.phones = member.phone.split(';').map(&:strip)
      member.save!
    end

    remove_column :members, :email
    remove_column :members, :phone
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

end
