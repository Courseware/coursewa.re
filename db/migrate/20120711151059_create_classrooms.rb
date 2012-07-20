class CreateClassrooms < ActiveRecord::Migration
  def change
    create_table :classrooms do |t|
      t.string :title
      t.text :description
      t.string :slug,       :null => false
      t.references :user

      t.timestamps
    end
    add_index :classrooms, :user_id
    add_index :classrooms, :slug, :unique => true
  end
end
