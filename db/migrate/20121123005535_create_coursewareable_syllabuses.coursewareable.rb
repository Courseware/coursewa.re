# This migration comes from coursewareable (originally 20120903113606)
class CreateCoursewareableSyllabuses < ActiveRecord::Migration
  def change
    create_table :coursewareable_syllabuses do |t|
      t.string :title
      t.text :content
      t.text :intro
      t.references :user
      t.references :classroom

      t.timestamps
    end
    add_index :coursewareable_syllabuses, :user_id
    add_index :coursewareable_syllabuses, :classroom_id
  end
end
