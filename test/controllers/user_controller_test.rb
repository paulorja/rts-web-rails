require 'test_helper'

class UserControllerTest < ActionController::TestCase
  test "should get post_login" do
    get :post_login
    assert_response :success
  end

  test "should get post_register" do
    get :post_register
    assert_response :success
  end

end
