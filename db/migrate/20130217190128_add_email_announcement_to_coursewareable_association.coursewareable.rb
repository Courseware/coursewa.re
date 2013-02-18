# This migration comes from coursewareable (originally 20130215212619)
class AddEmailAnnouncementToCoursewareableAssociation < ActiveRecord::Migration
  def change
    add_column :coursewareable_associations, :email_announcement, :string
  end
end
