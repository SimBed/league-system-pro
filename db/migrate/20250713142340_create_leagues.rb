class CreateLeagues < ActiveRecord::Migration[8.0]
  def change
    create_table :leagues do |t|
      t.string :name
      t.string :season

      t.timestamps
    end
    add_index :leagues, :name
    add_index :leagues, :season
  end
end
