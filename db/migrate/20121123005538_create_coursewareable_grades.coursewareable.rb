# This migration comes from coursewareable (originally 20120907132001)
class CreateCoursewareableGrades < ActiveRecord::Migration
  def change
    create_table :coursewareable_grades do |t|
      t.string :form, :default => :number
      t.integer :mark
      t.text :comment
      t.references :receiver
      t.references :assignment
      t.references :user
      t.references :classroom

      t.timestamps
    end
    add_index :coursewareable_grades, :receiver_id
    add_index :coursewareable_grades, :assignment_id
    add_index :coursewareable_grades, :user_id
    add_index :coursewareable_grades, :classroom_id
  end
end
