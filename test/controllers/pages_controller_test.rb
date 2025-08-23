require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @admin = users(:admin_user)
  end
  test "root should redirect to log in page when not logged in" do
    get "/"
    assert_redirected_to new_user_session_path
  end

  test "root should redirect to matches index when logged in" do
    sign_in @admin
    get "/"
    assert_redirected_to leagues_path
  end
end
