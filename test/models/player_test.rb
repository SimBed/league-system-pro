require "test_helper"

class PlayerTest < ActiveSupport::TestCase
  def setup
    @player = players(:dan)
  end

  test "should be valid" do
    assert @player.valid?
  end
end
