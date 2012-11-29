# This migration comes from coursewareable (originally 20120906150302)
class CreateCoursewareableResponses < ActiveRecord::Migration
  def change
    create_table :coursewareable_responses do |t|
      t.text :content
      t.text :quiz
      t.references :assignment
      t.references :user
      t.references :classroom

      t.timestamps
    end
    add_index :coursewareable_responses, :assignment_id
    add_index :coursewareable_responses, :user_id
    add_index :coursewareable_responses, :classroom_id
  end
end
