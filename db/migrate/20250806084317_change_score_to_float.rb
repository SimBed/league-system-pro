class ChangeScoreToFloat < ActiveRecord::Migration[8.0]
    # https://guides.rubyonrails.org/active_record_migrations.html#using-reversible
    # up/down simpler cleaner than revesible block
    def up
      change_column :participations, :score, :decimal, precision: 5, scale: 1
    end

    def down
      change_column :participations, :score, :integer
    end
end
