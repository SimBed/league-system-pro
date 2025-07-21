require "application_system_test_case"

class PlayersTest < ApplicationSystemTestCase
  setup do
    @player = players(:dan)
  end

  test "visiting the index" do
    visit players_path
    assert_selector "h5", text: "Players"
  end

  test "should create player" do
    visit players_path
    click_link nil, href: new_player_path

    fill_in "First name", with: @player.first_name
    fill_in "Last name", with: @player.last_name
    fill_in "Team", with: nil
    click_on "Create Player"

    assert_text "Player was successfully created"
  end

  test "should update Player" do
    visit players_path
    click_link nil, href: edit_player_path(@player)

    fill_in "First name", with: @player.first_name
    fill_in "Last name", with: "newname"
    click_on "Update Player"

    assert_text "Player was successfully updated"
  end
end
