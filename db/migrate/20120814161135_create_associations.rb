class CreateAssociations < ActiveRecord::Migration
  def change
    create_table :associations do |t|
      t.references :user
      t.references :classroom
      t.string :type

      t.timestamps
    end
    add_index :associations, :user_id
    add_index :associations, :classroom_id
  end
end
