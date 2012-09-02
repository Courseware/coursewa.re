class CreateLectures < ActiveRecord::Migration
  def change
    create_table :lectures do |t|
      t.string :slug, :null => false
      t.string :title
      t.text :content
      t.text :requisite
      t.references :parent_lecture
      t.references :user
      t.references :classroom

      t.timestamps
    end
    add_index :lectures, :parent_lecture_id
    add_index :lectures, :user_id
    add_index :lectures, :classroom_id
    add_index :lectures, :slug, :unique => true
  end
end
