class CreateLeagueAuths < ActiveRecord::Migration[8.0]
  def change
    create_table :league_auths do |t|
      t.references :user, null: false, foreign_key: true
      t.references :league, null: false, foreign_key: true
      t.integer :role

      t.timestamps
    end
    add_index :league_auths, :role
  end
end
