class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.integer    :year,      null: false
      t.references :member,    index: true

      t.timestamps
    end
  end
end
