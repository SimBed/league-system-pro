require "test_helper"

class TeamTest < ActiveSupport::TestCase
  def setup
    @team = teams(:team1)
  end

  test "should be valid" do
    assert @team.valid?
  end
end
