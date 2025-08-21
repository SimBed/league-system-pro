require "test_helper"

class MatchesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @match = matches(:match1)
    @dan = players(:dan)
    @kev = players(:kev)
    @andy = players(:andy)
  end

  # test "should get index when logged-in" do
  #   sign_in @user
  #   get matches_path
  #   assert_response :success
  # end

  test "should get new when logged-in" do
    sign_in @user
    get new_match_path
    assert_response :success
  end

  test "should create match when logged-in" do
    sign_in @user
    assert_difference -> { Match.count } => 1, -> { Participation.count } => 3 do
      post matches_path, params: { match: { date: Date.parse("3 July 2025"), league_id: @match.league_id,
                                            participations_attributes: {
                                              "0" => { score: 10, participant_id: @dan.id, participant_type: "Player" },
                                              "1" => { score: 5, participant_id: @kev.id, participant_type: "Player" },
                                              "2" => { score: 1, participant_id: @andy.id, participant_type: "Player" }
                                               } } }
    end

    assert_redirected_to @match.league
  end

  test "should show match when logged-in" do
    sign_in @user
    get match_path(@match)
    assert_response :success
  end

  test "should get edit when logged-in" do
    sign_in @user
    get edit_match_path(@match)
    assert_response :success
  end

  test "should update match when logged-in" do
    sign_in @user
    participation_to_edit = @match.participations.where(participant_id: @dan.id).first
    original_score = participation_to_edit.score
    assert_no_difference -> { Match.count }, -> { Participation.count } do
      patch match_path(@match), params: { match: { date: @match.date.advance(days: 1),
                                                   participations_attributes: {
                                                    "0" => { score: original_score + 1, id: participation_to_edit.id, participant_id: @dan.id }
                                               } } }
    end

    assert_equal original_score + 1, @match.participations.where(participant_id: @dan.id).first.score

    assert_redirected_to @match.league
  end

  test "should destroy match when logged-in" do
    sign_in @user
    assert_difference("Match.count", -1) do
      delete match_path(@match)
    end

    assert_redirected_to @match.league
  end
end
