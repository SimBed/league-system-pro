user1 = User.create!(email: 'dan@gmail.com', password: 'password', password_confirmation: 'password')
user2 = User.create!(email: 'kev@gmail.com', password: 'password', password_confirmation: 'password')
User.create!(email: 'andy@gmail.com', password: 'password', password_confirmation: 'password')
User.create!(email: 'elie@gmail.com', password: 'password', password_confirmation: 'password')

league1 = League.create!(name: 'BestHand',
               season: 'Summer',
               participants_per_match: 3,
               participant_type: 'player')

league2 = League.create!(name: 'BestHand',
               season: 'Winter',
               participants_per_match: 3,
               participant_type: 'player')

user1.league_auths.create!(league: league1, role: :admin)
user1.league_auths.create!(league: league2, role: :admin)
user2.league_auths.create!(league: league1, role: :member)
user2.league_auths.create!(league: league2, role: :viewer)

Dan = Player.create!(first_name: 'Dan', last_name: 'S')
Kev = Player.create!(first_name: 'Kev', last_name: 'S')
Andy = Player.create!(first_name: 'Andy', last_name: 'K')
Elie = Player.create!(first_name: 'Elie', last_name: 'D')

user1.player_auths.create!(player: Dan, role: :admin)
user1.player_auths.create!(player: Kev, role: :admin)
user1.player_auths.create!(player: Andy, role: :admin)

match1 = Match.create!(date: Date.parse('1 July 2025'), league: league1)

Participation.create!(score: 10, match: match1, participatable_type: 'Player', participatable_id: Dan.id)
Participation.create!(score: 5, match: match1, participatable_type: 'Player', participatable_id: Kev.id)
Participation.create!(score: 0, match: match1, participatable_type: 'Player', participatable_id: Andy.id)

match2 = Match.create!(date: Date.parse('2 July 2025'), league: league1)

Participation.create!(score: 3, match: match2, participatable_type: 'Player', participatable_id: Dan.id)
Participation.create!(score: 6, match: match2, participatable_type: 'Player', participatable_id: Kev.id)
Participation.create!(score: 2, match: match2, participatable_type: 'Player', participatable_id: Andy.id)

match3 = Match.create!(date: Date.parse('3 July 2025'), league: league2)

Participation.create!(score: 4, match: match3, participatable_type: 'Player', participatable_id: Dan.id)
Participation.create!(score: 2, match: match3, participatable_type: 'Player', participatable_id: Kev.id)
Participation.create!(score: 4, match: match3, participatable_type: 'Player', participatable_id: Andy.id)
