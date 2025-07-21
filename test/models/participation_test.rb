require "test_helper"

class ParticipationTest < ActiveSupport::TestCase
  def setup
    @participation = participations(:participation1)
  end

  test "should be valid" do
    assert @participation.valid?
  end
end
