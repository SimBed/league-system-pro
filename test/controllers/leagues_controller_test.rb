require "test_helper"

class LeaguesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @league = leagues(:league1)
  end

  test "should get index when logged-in" do
    sign_in @user
    get leagues_path
    assert_response :success
  end

  test "should redirect index when not logged_in" do
    get leagues_path
    assert_redirected_to new_user_session_path
  end

  test "should get new when logged-in" do
    sign_in @user
    get new_league_path
    assert_response :success
  end

  test "should redirect new when not logged-in" do
    get new_league_path
    assert_redirected_to new_user_session_path
  end

  test "should create league when logged-in" do
    sign_in @user
    assert_difference("League.count") do
      post leagues_path, params: { league: { name: @league.name,
                                             season: "Season3",
                                             participants_per_match: 2,
                                             participant_type: "player" } }
    end

    assert_redirected_to leagues_path
  end

  test "should redirect create league when not logged-in" do
    assert_no_difference("League.count") do
      post leagues_path, params: { league: { name: @league.name,
                                             season: "Season3",
                                             participants_per_match: 2,
                                             participant_type: "Player" } }
    end

    assert_redirected_to new_user_session_path
  end

  test "should show league when logged-in" do
    sign_in @user
    get league_path(@league)
    assert_response :success
  end

  test "should redirect show league when not logged-in" do
    get league_path(@league)
    assert_redirected_to new_user_session_path
  end

  test "should get edit when logged-in" do
    sign_in @user
    get edit_league_path(@league)
    assert_response :success
  end

  test "should redirect edit when not logged-in" do
    get edit_league_path(@league)
    assert_redirected_to new_user_session_path
  end

  test "should update league when logged-in" do
    sign_in @user
    patch league_path(@league), params: { league: { name: "leagueZ", season: "SeasonZ" } }
    assert_redirected_to leagues_path
  end

  test "should redirect update league when not logged-in" do
    orig_league_name = @league.name
    patch league_path(@league), params: { league: { name: "leagueZ", season: "SeasonZ" } }
    assert orig_league_name, @league.reload.name
    assert_redirected_to new_user_session_path
  end

  test "should destroy league when logged-in" do
    sign_in @user
    assert_difference("League.count", -1) do
      delete league_path(@league)
    end

    assert_redirected_to leagues_path
  end

  test "should redirect destroy league when not logged-in" do
    assert_no_difference "League.count" do
      delete league_path(@league)
    end

    assert_redirected_to new_user_session_path
  end
end
