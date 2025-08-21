class RenameParticipatableToParticipant < ActiveRecord::Migration[8.0]
  # run with up/down methods rather than in a change block as Rails won't be able to reverse remove_index
  def up
    rename_column :participations, :participatable_type, :participant_type
    rename_column :participations, :participatable_id,   :participant_id

    remove_index :participations, name: "index_participations_on_participatable"

    add_index :participations, [ :participant_type, :participant_id ], name: "index_participations_on_participant"
  end

  def down
    rename_column :participations, :participant_type, :participatable_type
    rename_column :participations, :participant_id,   :participatable_id

    remove_index :participations, name: "index_participations_on_participant"

    add_index :participations, [ :participatable_type, :participatable_id ], name: "index_participations_on_participatable"
  end
end
