require "test_helper"

class MatchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @match = matches(:match1)
    @dan = players(:dan)
    @kev = players(:kev)
    @andy = players(:andy)
  end

  test "should get index" do
    get matches_path
    assert_response :success
  end

  test "should get new" do
    get new_match_path
    assert_response :success
  end

  test "should create match" do
    assert_difference -> { Match.count } => 1, -> { Participation.count } => 3 do
      post matches_path, params: { match: { date: Date.parse("3 July 2025"), league_id: @match.league_id,
                                            participations_attributes: {
                                              "0" => { score: 10, participatable_id: @dan.id },
                                              "1" => { score: 5, participatable_id: @kev.id },
                                              "2" => { score: 1, participatable_id: @andy.id }
                                               } } }
    end

    assert_redirected_to matches_path
  end

  test "should show match" do
    get match_path(@match)
    assert_response :success
  end

  test "should get edit" do
    get edit_match_path(@match)
    assert_response :success
  end

  test "should update match" do
    participation_to_edit = @match.participations.where(participatable_id: @dan.id).first
    original_score = participation_to_edit.score
    assert_no_difference -> { Match.count }, -> { Participation.count } do
      patch match_path(@match), params: { match: { date: @match.date.advance(days: 1),
                                                   participations_attributes: {
                                                    "0" => { score: original_score + 1, id: participation_to_edit.id, participatable_id: @dan.id }
                                               } } }
    end

    assert_equal original_score + 1, @match.participations.where(participatable_id: @dan.id).first.score

    assert_redirected_to matches_path
  end

  test "should destroy match" do
    assert_difference("Match.count", -1) do
      delete match_path(@match)
    end

    assert_redirected_to matches_path
  end
end
