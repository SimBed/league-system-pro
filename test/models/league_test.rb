require "test_helper"

class LeagueTest < ActiveSupport::TestCase
  def setup
    @league = leagues(:league1)
  end

  test "should be valid" do
    assert @league.valid?
  end

  test "name should be present" do
    @league.name = "     "

    refute @league.valid?
  end

  test "season should be present" do
    @league.season = "     "

    refute @league.valid?
  end

  test "participants_per_match should be in range" do
    @league.participants_per_match = 0

    refute @league.valid?

    @league.participants_per_match = 11

    refute @league.valid?

    @league.participants_per_match = 2.5

    refute @league.valid?
  end

  test "participant_type should be player or team" do
    @league.participant_type = "group"

    refute @league.valid?
  end

  test "name and season combo should be unique per owner" do
    # duplicate league name/season generally ok
    league = @league.dup
    assert league.valid?

    # duplicate league name/season not ok for same admin
    league.creator = @league.admin
    refute league.valid?
  end

  test "#full_name" do
    assert_equal "League1 Season1", @league.full_name
  end

  test "roughly input name cleaned up" do
    roughly_named_league = @league.dup
    roughly_named_league .update(name: "  BestHand ", season: "   winter   ")

    assert_equal "Best Hand Winter", roughly_named_league.full_name
  end
end
