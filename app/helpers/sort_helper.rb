module SortHelper
  SORT_TIE_BREAKERS = {
    total_score:   [ "wins" ],
    wins:          [ "total_score" ],
    average_score: [ "total_score", "wins" ],
    default:       [ "total_score" ]
  }.freeze
end
