# This migration comes from coursewareable (originally 20120901132251)
class CreateCoursewareableLectures < ActiveRecord::Migration
  def change
    create_table :coursewareable_lectures do |t|
      t.string :slug, :null => false
      t.string :title
      t.text :content
      t.text :requisite
      t.references :parent_lecture
      t.references :user
      t.references :classroom

      t.timestamps
    end
    add_index :coursewareable_lectures, :parent_lecture_id
    add_index :coursewareable_lectures, :user_id
    add_index :coursewareable_lectures, :classroom_id
    add_index :coursewareable_lectures, :slug, :unique => true
  end
end
