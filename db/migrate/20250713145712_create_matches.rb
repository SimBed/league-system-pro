class CreateMatches < ActiveRecord::Migration[8.0]
  def change
    create_table :matches do |t|
      t.date :date, null: false
      t.references :league, null: false, foreign_key: true

      t.timestamps
    end
    add_index :matches, :date
  end
end
