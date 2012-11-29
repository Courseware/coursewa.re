# This migration comes from coursewareable (originally 20120711151059)
class CreateCoursewareableClassrooms < ActiveRecord::Migration
  def change
    create_table :coursewareable_classrooms do |t|
      t.string      :title
      t.text        :description
      t.string      :slug,                  :null => false
      t.references  :owner
      t.integer     :memberships_count,     default: 0
      t.integer     :collaborations_count,  default: 0
      t.text        :settings

      t.timestamps
    end
    add_index :coursewareable_classrooms, :owner_id
    add_index :coursewareable_classrooms, :slug, :unique => true

  end
end
