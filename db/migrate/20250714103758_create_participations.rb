class CreateParticipations < ActiveRecord::Migration[8.0]
  def change
    create_table :participations do |t|
      t.integer :score, null: false
      t.references :match, null: false, foreign_key: true
      t.references :participatable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
