require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
  end
  test "root should redirect to log in page when not logged in" do
    get "/"
    assert_redirected_to new_user_session_path
  end

  test "root should redirect to matches index when logged in" do
    sign_in @user
    get "/"
    assert_redirected_to matches_path
  end
end
