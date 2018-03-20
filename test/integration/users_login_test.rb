require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "login with invalid information" do
    get login_url
    assert_template 'sessions/new'
    post login_url, params: { session: {
      email: "invalid email",
      password: "12345",
      } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_url
    assert flash.empty?
  end

  test "login behavior followed by logout" do
    get login_url
    post login_url, params: { session: {
      email: @user.email,
      password: 'password'
      } }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_url
    assert_not is_logged_in?
    assert_redirected_to root_url
    # 模拟在其他窗口点击 log out
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_url, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "login with remembering" do
    log_in_as(@user, remember_me: "1") # log_in_as from test_helper.rb
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end

  test "login without remembering" do
    log_in_as(@user, remember_me: "1")
    delete logout_path
    log_in_as(@user, remember_me: "0")
    assert_empty cookies['remember_token']
  end
end
