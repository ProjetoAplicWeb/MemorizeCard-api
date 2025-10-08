class CreatePasswordResets < ActiveRecord::Migration[8.0]
  def change
    create_table :password_resets do |t|
      t.references :user, null: false, foreign_key: true
      t.string :token_hash, null: false
      t.datetime :expires_at, null: false
      t.integer :attempts, null: false, default: 0

      t.timestamps
    end
  end
end
