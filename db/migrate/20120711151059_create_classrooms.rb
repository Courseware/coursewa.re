class CreateClassrooms < ActiveRecord::Migration
  def change
    create_table :classrooms do |t|
      t.string      :title
      t.text        :description
      t.string      :slug,                  :null => false
      t.references  :owner
      t.integer     :memberships_count,     default: 0
      t.integer     :collaborations_count,  default: 0
      t.text        :settings

      t.timestamps
    end
    add_index :classrooms, :owner_id
    add_index :classrooms, :slug, :unique => true

  end
end
