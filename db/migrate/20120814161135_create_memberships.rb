class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :user
      t.references :classroom

      t.timestamps
    end
    add_index :memberships, :user_id
    add_index :memberships, :classroom_id
  end
end
