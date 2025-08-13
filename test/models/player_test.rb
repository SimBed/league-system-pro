require "test_helper"

class PlayerTest < ActiveSupport::TestCase
  def setup
    @player = players(:dan)
  end

  test "should be valid" do
    assert @player.valid?
  end

  test "first_name should be present" do
    @player.first_name = "     "

    refute @player.valid?
  end

  test "last_name should be present" do
    @player.last_name = "     "

    refute @player.valid?
  end

  test "first_name and last_name combo should be unique per creator" do
    # duplicate player full_name generally ok
    player = @player.dup
    assert player.valid?

    # duplicate player full_name not ok for same admin
    player.creator = @player.admin
    refute player.valid?
  end

  test "#full_name" do
    assert_equal "Dan Simmo", @player.full_name
  end

  test "roughly input name cleaned up" do
    roughly_named_player = @player.dup
    roughly_named_player .update(first_name: "  nad ", last_name: "   ommis   ")

    assert_equal "Nad Ommis", roughly_named_player.full_name
  end
end
