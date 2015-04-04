class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string  :name,            null: false, limit: 64
      t.string  :security_id,     null: false, limit: 64
      t.date    :birthdate,       null: false
      t.integer :gender,          null: false
      t.integer :member_type,     null: false
      t.boolean :permanent,       null: false
      t.string  :email,           null: false
      t.string  :phone,           null: false
      t.string  :address,         null: false
      t.string  :occupation,      null: false
      t.string  :company,         null: false
      t.string  :education,       null: false
      t.string  :facebook
      t.integer :grad_class
      t.integer :grad_year
      t.string  :grad_id,         limit: 16
      t.integer :grad_department

      t.timestamps
    end

    add_index :members, :name
    add_index :members, :security_id, unique: true

  end
end
