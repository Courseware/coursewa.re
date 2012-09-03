class CreateSyllabuses < ActiveRecord::Migration
  def change
    create_table :syllabuses do |t|
      t.string :title
      t.text :content
      t.text :intro
      t.references :user
      t.references :classroom

      t.timestamps
    end
    add_index :syllabuses, :user_id
    add_index :syllabuses, :classroom_id
  end
end
