# This migration comes from coursewareable (originally 20130122115102)
class AddDescriptionToCoursewareableUser < ActiveRecord::Migration
  def change
    add_column :coursewareable_users, :description, :text
  end
end
