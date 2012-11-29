# This migration comes from coursewareable (originally 20120828110726)
class CreateCoursewareableAssets < ActiveRecord::Migration
  def change
    create_table :coursewareable_assets do |t|
      t.references  :user
      t.references  :classroom
      t.text        :description
      t.string      :type
      t.integer     :assetable_id
      t.string      :assetable_type
      t.string      :attachment_file_name
      t.string      :attachment_content_type
      t.integer     :attachment_file_size
      t.datetime    :attachment_updated_at
    end
    add_index :coursewareable_assets, :user_id
    add_index :coursewareable_assets, :classroom_id
    add_index :coursewareable_assets, :assetable_id
    add_index :coursewareable_assets, :assetable_type

  end
end
