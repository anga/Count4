require 'test_helper'

class GamesControllerTest < ActionController::TestCase
  test "should get board_1" do
    get :board_1
    assert_response :success
  end

  test "should get board_2" do
    get :board_2
    assert_response :success
  end

  test "should get muvement" do
    get :muvement
    assert_response :success
  end

end
