class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :slug
      t.string :title
      t.text :content
      t.text :requisite
      t.references :parent_course
      t.references :user
      t.references :classroom

      t.timestamps
    end
    add_index :courses, :parent_course_id
    add_index :courses, :user_id
    add_index :courses, :classroom_id
    add_index :courses, :slug, :unique => true
  end
end
