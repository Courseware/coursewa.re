class CreateGrades < ActiveRecord::Migration
  def change
    create_table :grades do |t|
      t.string :form, :default => :number
      t.integer :mark
      t.text :comment
      t.references :receiver
      t.references :assignment
      t.references :user
      t.references :classroom

      t.timestamps
    end
    add_index :grades, :receiver_id
    add_index :grades, :assignment_id
    add_index :grades, :user_id
    add_index :grades, :classroom_id
  end
end
