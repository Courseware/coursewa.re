class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.text     :description
      t.string   :type
      t.integer  :assetable_id
      t.string   :assetable_type
      t.string   :attachment_file_name
      t.string   :attachment_content_type
      t.integer  :attachment_file_size
      t.datetime :attachment_updated_at
    end
  end
end
