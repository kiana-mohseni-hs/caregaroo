require 'test_helper'

class PilotSignupsControllerTest < ActionController::TestCase
  setup do
    @pilot_signup = pilot_signups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pilot_signups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pilot_signup" do
    assert_difference('PilotSignup.count') do
      post :create, :pilot_signup => @pilot_signup.attributes
    end

    assert_redirected_to pilot_signup_path(assigns(:pilot_signup))
  end

  test "should show pilot_signup" do
    get :show, :id => @pilot_signup.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @pilot_signup.to_param
    assert_response :success
  end

  test "should update pilot_signup" do
    put :update, :id => @pilot_signup.to_param, :pilot_signup => @pilot_signup.attributes
    assert_redirected_to pilot_signup_path(assigns(:pilot_signup))
  end

  test "should destroy pilot_signup" do
    assert_difference('PilotSignup.count', -1) do
      delete :destroy, :id => @pilot_signup.to_param
    end

    assert_redirected_to pilot_signups_path
  end
end
