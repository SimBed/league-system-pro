json.extract! player, :id, :first_name, :last_name, :team_id, :created_at, :updated_at
json.url player_url(player, format: :json)
