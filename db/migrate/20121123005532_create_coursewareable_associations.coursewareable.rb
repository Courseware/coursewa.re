# This migration comes from coursewareable (originally 20120814161135)
class CreateCoursewareableAssociations < ActiveRecord::Migration
  def change
    create_table :coursewareable_associations do |t|
      t.references :user
      t.references :classroom
      t.string :type

      t.timestamps
    end
    add_index :coursewareable_associations, :user_id
    add_index :coursewareable_associations, :classroom_id
  end
end
