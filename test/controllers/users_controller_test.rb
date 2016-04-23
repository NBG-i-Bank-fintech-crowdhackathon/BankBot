require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: { account_id: @user.account_id, bank_id: @user.bank_id, clear_state: @user.clear_state, email: @user.email, fb_id: @user.fb_id, first_name: @user.first_name, last_name: @user.last_name, location_lat: @user.location_lat, location_long: @user.location_long, pin: @user.pin, rating: @user.rating, state: @user.state }
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    patch :update, id: @user, user: { account_id: @user.account_id, bank_id: @user.bank_id, clear_state: @user.clear_state, email: @user.email, fb_id: @user.fb_id, first_name: @user.first_name, last_name: @user.last_name, location_lat: @user.location_lat, location_long: @user.location_long, pin: @user.pin, rating: @user.rating, state: @user.state }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end
end
