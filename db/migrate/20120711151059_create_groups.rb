class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :title
      t.text :description
      t.string :slug,       :null => false
      t.references :user

      t.timestamps
    end
    add_index :groups, :user_id
    add_index :groups, :slug, :unique => true
  end
end
