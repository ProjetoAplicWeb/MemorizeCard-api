class CreateCards < ActiveRecord::Migration[8.0]
  def change
    create_table :cards do |t|
      t.string :term
      t.string :definition
      t.integer :last_difficulty, null: true
      t.date :last_view, null: true
      t.references :deck, null: false, foreign_key: true

      t.timestamps
    end
  end
end
