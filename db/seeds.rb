League.create!(name: 'League1',
               season: 'Season1',
               match_participants: 3,
               participant_type: 'player')
League.create!(name: 'League2',
               season: 'Season2',
               match_participants: 3,
               participant_type: 'player')

Player.create!(first_name: 'Dan',
               last_name: 'S')
Player.create!(first_name: 'Kev',
               last_name: 'S')
Player.create!(first_name: 'Andy',
               last_name: 'K')

# Match.create!(date: Date.parse('1 July 2025'),
#               league: league1)
