require "test_helper"

class LeagueTest < ActiveSupport::TestCase
  def setup
    @league = leagues(:league1)
  end

  test "should be valid" do
    assert @league.valid?
  end
end
