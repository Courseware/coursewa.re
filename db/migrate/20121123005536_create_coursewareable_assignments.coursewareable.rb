# This migration comes from coursewareable (originally 20120906125822)
class CreateCoursewareableAssignments < ActiveRecord::Migration
  def change
    create_table :coursewareable_assignments do |t|
      t.string :slug, :null => false
      t.string :title
      t.text :content
      t.text :quiz
      t.references :lecture
      t.references :user
      t.references :classroom

      t.timestamps
    end
    add_index :coursewareable_assignments, :lecture_id
    add_index :coursewareable_assignments, :user_id
    add_index :coursewareable_assignments, :classroom_id
    add_index :coursewareable_assignments, :slug, :unique => true
  end
end
