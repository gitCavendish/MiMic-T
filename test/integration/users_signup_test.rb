require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid params should not create user successfully" do
  assert_no_difference User.count.to_s do
    get signup_path
    post signup_path, params: { user: {
      name: "",
      email: "invalid",
      password: "foo",
      password_confirmation: "bar"
      } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert-danger'
  end

  test "valid signup" do
    get signup_path
    assert_difference 'User.count', 1  do
      post users_path, params: { user:{
        name: "Example User",
        email: "user@example.com",
        password: "password",
        password_confirmation: "password"
        } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert flash.any? 
  end

end
