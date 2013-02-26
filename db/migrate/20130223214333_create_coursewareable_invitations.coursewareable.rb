# This migration comes from coursewareable (originally 20130219160555)
class CreateCoursewareableInvitations < ActiveRecord::Migration
  def change
    create_table :coursewareable_invitations do |t|
      t.references :classroom
      t.references :creator
      t.references :user
      t.string :email
      t.string :role

      t.timestamps
    end

    add_index :coursewareable_invitations, :email
    add_index :coursewareable_invitations, :classroom_id
    add_index :coursewareable_invitations, :creator_id
    add_index :coursewareable_invitations, :user_id
  end
end
