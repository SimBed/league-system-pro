require "test_helper"

class PlayersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @player = players(:dan)
  end

  test "should get index when logged-in" do
    sign_in @user
    get players_path
    assert_response :success
  end

  test "should get new when logged-in" do
    sign_in @user
    get new_player_path
    assert_response :success
  end

  test "should create player when logged-in" do
    sign_in @user
    assert_difference("Player.count") do
      post players_path, params: { player: { first_name: "Richard", last_name: "St", team_id: nil } }
    end

    assert_redirected_to players_path
  end

  test "should show player when logged-in" do
    sign_in @user
    get player_path(@player)
    assert_response :success
  end

  test "should get edit when logged-in" do
    sign_in @user
    get edit_player_path(@player)
    assert_response :success
  end

  test "should update player when logged-in" do
    sign_in @user
    patch player_path(@player), params: { player: { first_name: "Ricky" } }
    assert_redirected_to players_path
  end

  test "should destroy player when logged-in" do
    sign_in @user
    assert_difference("Player.count", -1) do
      delete player_path(@player)
    end

    assert_redirected_to players_path
  end
end
