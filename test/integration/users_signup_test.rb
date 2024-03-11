require "test_helper"

class UsersSignup < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end
end

class UsersSignupTest < UsersSignup
  _bad_params = {
    user: {
      name: "",
      email: "invalid@email",
      password: "123",
      password_confirmation: "456"
    }
  }
  _good_params = {
    user: {
      name: "Example User",
      email: "user@example.com",
      password: "password",
      password_confirmation: "password"
    }
  }
  test "invalid signup information" do
    get signup_path
    assert_no_difference "User.count" do
      post users_path, params: _bad_params
    end
    assert_response :unprocessable_entity
    assert_template 'users/new'
    assert_select 'div#signup_form'
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
    assert_select 'div.field_with_errors'
  end

  test "valid signup information with account activation" do
    assert_difference "User.count", 1 do
      post users_path, params: _good_params
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
  end
end

class AccountActivationTest < UsersSignup
  def setup
    super
    post users_path, params: { user: { name: "Example User",
                                       email: "user@example.com",
                                       password: "password",
                                       password_confirmation: "password" } }
    @user = assigns(:user)
  end

  test "should not be activated" do
    assert_not @user.activated?
  end

  test "should not be able to log in before account activation" do
    log_in_as(@user)
    assert_not is_logged_in?
  end

  test "should not be able to log in with invalid activation token" do
    get edit_account_activation_path("invalid token", email: @user.email)
    assert_not is_logged_in?
  end

  test "should not be able to log in with invalid email" do
    get edit_account_activation_path(@user.activation_token, email: "wrong")
    assert_not is_logged_in?
  end

  test "should log in successfully with valid activation token and email" do
    get edit_account_activation_path(@user.activation_token, email: @user.email)
    assert @user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
