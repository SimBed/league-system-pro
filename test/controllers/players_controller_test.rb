require "test_helper"

class PlayersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @player = players(:dan)
  end

  test "should get index" do
    get players_path
    assert_response :success
  end

  test "should get new" do
    get new_player_path
    assert_response :success
  end

  test "should create player" do
    assert_difference("Player.count") do
      post players_path, params: { player: { first_name: "Richard", last_name: "St", team_id: nil } }
    end

    assert_redirected_to players_path
  end

  test "should show player" do
    get player_path(@player)
    assert_response :success
  end

  test "should get edit" do
    get edit_player_path(@player)
    assert_response :success
  end

  test "should update player" do
    patch player_path(@player), params: { player: { first_name: "Ricky" } }
    assert_redirected_to players_path
  end

  test "should destroy player" do
    assert_difference("Player.count", -1) do
      delete player_path(@player)
    end

    assert_redirected_to players_path
  end
end
