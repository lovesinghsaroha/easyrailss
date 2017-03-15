require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get welcome" do
    get users_welcome_url
    assert_response :success
  end

  test "should get dashboard" do
    get users_dashboard_url
    assert_response :success
  end

end
