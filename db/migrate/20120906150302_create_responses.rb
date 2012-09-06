class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.text :content
      t.text :quiz
      t.references :assignment
      t.references :user
      t.references :classroom

      t.timestamps
    end
    add_index :responses, :assignment_id
    add_index :responses, :user_id
    add_index :responses, :classroom_id
  end
end
