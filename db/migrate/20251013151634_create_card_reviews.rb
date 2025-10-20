class CreateCardReviews < ActiveRecord::Migration[8.0]
  def change
    create_table :card_reviews do |t|
      t.integer :difficulty
      t.datetime :date
      t.references :card, null: false, foreign_key: true

      t.timestamps
    end
  end
end
