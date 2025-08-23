require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @admin = users(:admin_user)
    @user1 = users(:user1)
    @user2 = users(:user2)
  end

  test "should get index when logged-in as admin" do
    sign_in @admin
    get users_path
    assert_response :success
  end

  test "should redirect index when not logged_in as admin" do
    sign_in @user1
    get users_path
    assert_redirected_to root_path
  end

  test "should destroy user when logged in as admin" do
    sign_in @admin
    assert_difference "User.count", -1 do
      delete user_path(@user1)
    end
    assert_equal "User was successfully removed", flash[:success]
  end

  test "should not destroy user when not logged in as admin" do
    sign_in @user1
    assert_no_difference "User.count" do
      delete user_path(@user2)
    end
    assert_redirected_to root_path
  end
end
