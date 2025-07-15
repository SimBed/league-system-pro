class CreatePlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :players do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.references :team, foreign_key: true

      t.timestamps
    end
    add_index :players, :first_name
    add_index :players, :last_name
  end
end
