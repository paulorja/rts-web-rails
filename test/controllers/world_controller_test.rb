require 'test_helper'

class WorldControllerTest < ActionController::TestCase
  test "should get world" do
    get :world
    assert_response :success
  end

  test "should get world_zoom" do
    get :world_zoom
    assert_response :success
  end

  test "should get world_detail" do
    get :world_detail
    assert_response :success
  end

end
