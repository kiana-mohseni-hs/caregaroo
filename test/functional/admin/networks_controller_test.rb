require 'test_helper'

class Admin::NetworksControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get set_page" do
    get :set_page
    assert_response :success
  end

end
