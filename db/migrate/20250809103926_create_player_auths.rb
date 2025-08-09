class CreatePlayerAuths < ActiveRecord::Migration[8.0]
  def change
    create_table :player_auths do |t|
      t.references :user, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true
      t.integer :role

      t.timestamps
    end
      add_index :player_auths, :role
  end
end
