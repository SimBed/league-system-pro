require "test_helper"

class Admin::ImpersonationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @admin = users(:admin_user)
    @user1 = users(:user1)
    @user2 = users(:user2)
  end

  test "admin can view as another user" do
    sign_in @admin
    post impersonate_user_path(@user1)
    assert_redirected_to leagues_path
    follow_redirect!
    # File.write("testoutput.html", response.body)
    # puts response.body
    # puts "Redirected to: #{path}"  # `path` is a helper in integration tests
    # puts "Response status: #{response.status}"
    # puts "Content type: #{response.content_type}"
    # puts "Response body: #{response.body.inspect}"
    assert_select "div", /viewing as/
    assert_equal "Now viewing as #{@user1.email}", flash[:success]
  end

  test "non-admin cannot view as another user" do
    sign_in @user2
    post impersonate_user_path(@user1)
    assert_redirected_to root_path
    follow_redirect!
    follow_redirect! # 2nd redirect at root_path
    assert_select "footer>div", /logged in as: #{@user2.email}/
  end

  # should probable protect (and test) against (malaevolent) requests to this endpont when true_user.nil?
  test "should be able to stop view as user when logged in as admin" do
    sign_in @admin
    post impersonate_user_path(@user1)
    follow_redirect!
    delete stop_impersonating_path
    assert_redirected_to users_path # OK for now - we dont want a redirect just a qucik turbostream to update banner and flash
    follow_redirect!
    assert_select "footer>div", text: /logged in as: #{@admin.email}/
  end
end
