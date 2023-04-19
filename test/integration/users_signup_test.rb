require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    _params = {
      user: {
        name: "",
        email: "invalid@email",
        password: "123",
        password_confirmation: "456"
      }
    }
    get signup_path
    assert_no_difference "User.count" do
      post users_path, params: _params
    end
    assert_response :unprocessable_entity
    assert_template 'users/new'
    assert_select 'div#signup_form'
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
    assert_select 'div.field_with_errors'
  end

  test "valid signup information" do
    assert_difference "User.count", 1 do
      post users_path, params: { user: { name: "Example User",
                                         email: "user@example.com",
                                         password: "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert_select 'div.alert-success'
  end
end
