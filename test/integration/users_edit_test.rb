require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  include SessionsHelper
  def setup
    @user = users(:caven)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
    patch user_path(@user), params: { user: {
        name: "",
        email: "foo@invalid",
        pasword: "foo",
        password_confirmation: "bar"
      } }
    assert_template "users/edit"
    assert_select "div.alert-danger"
  end

  test "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: {
      name: name,
      email: email,
      password: "",
      password_confirmation: ""
      } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload # 从数据库中拿到最新的@user信息
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  # 用户在编辑页面登陆后仍然回到edit页面
  # 更新成功后再转到show
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = "Foo bar"
    email = "foo@bar.com"
    patch user_path(@user), params: {user: {
      name: name,
      email: email,
      password: "",
      password_confirmation: ""
      }}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test "redirect to user_path after first login" do
    log_in_as(@user)
    get edit_user_path(@user)
    get root_url
    log_out
    assert_equal nil, session[:forwarding_url]
    get login_path
    log_in_as(@user)
    assert_redirected_to(@user)

  end



end
