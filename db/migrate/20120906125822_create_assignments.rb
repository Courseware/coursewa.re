class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.string :slug, :null => false
      t.string :title
      t.text :content
      t.text :quiz
      t.references :lecture
      t.references :user
      t.references :classroom

      t.timestamps
    end
    add_index :assignments, :lecture_id
    add_index :assignments, :user_id
    add_index :assignments, :classroom_id
    add_index :assignments, :slug, :unique => true
  end
end
