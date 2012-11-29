# This migration comes from coursewareable (originally 20120711135621)
# Migration responsible for creating a table with activities
class CreateCoursewareableActivities < ActiveRecord::Migration
  def change
    create_table :coursewareable_activities do |t|
      t.belongs_to :trackable, :polymorphic => true
      t.belongs_to :owner, :polymorphic => true
      t.belongs_to :recipient, :polymorphic => true
      t.string  :key
      t.text    :parameters

      t.timestamps
    end
  end
end
