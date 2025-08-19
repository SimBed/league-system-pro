require "application_system_test_case"

class LeaguesTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @league = leagues(:league1)
  end

  test "visiting the index" do
    sign_in @user
    visit leagues_path
    assert_selector "h5", text: "Leagues"
  end

  test "should create league" do
    sign_in @user
    visit leagues_path
    click_link nil, href: new_league_path

    fill_in "Name", with: @league.name
    fill_in "Season", with: "Season3"
    fill_in "Participants per match", with: @league.participants_per_match
    select "player", from: "Participant type"

    click_on "Create League"

    assert_text "League was successfully created."
  end

  test "should update League" do
    sign_in @user
    visit leagues_path
    click_link nil, href: edit_league_path(@league)
    # click_on "Edit League", match: :first

    fill_in "Name", with: @league.name
    fill_in "Season", with: "Season3"
    click_on "Update League"

    assert_text "League was successfully updated"
  end
end
