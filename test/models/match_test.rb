require "test_helper"

class MatchTest < ActiveSupport::TestCase
  def setup
    @match = matches(:match1)
  end

  test "should be valid" do
    assert @match.valid?
  end
end
