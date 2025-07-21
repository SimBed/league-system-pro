class CreateLeagues < ActiveRecord::Migration[8.0]
  def change
    create_table :leagues do |t|
      t.string :name, null: false
      t.string :season, null: false
      t.integer :participants_per_match, null: false
      t.string :participant_type, null: false

      t.timestamps
    end
    add_index :leagues, :name
    add_index :leagues, :season
  end
end
