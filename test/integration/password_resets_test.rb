require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:caven)
  end

  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    # 无效电子邮件
    post password_resets_path, params: { password_reset:{
      email: ""
      }}
    assert_not flash.empty?
    assert_template 'password_resets/new'
    # 有效电子邮件
    post password_resets_path, params: {password_reset:{
      email: @user.email
      }}
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    # 密码重设页面 edit
    user = assigns(:user)
      # 错误邮件地址
      get edit_password_reset_path(user.reset_token, email: "")
      assert_redirected_to root_url
      # 用户未激活
      user.toggle!(:activated)
      get edit_password_reset_path(user.reset_token, email: user.email)
      assert_redirected_to root_url
      user.toggle!(:activated)
      # 电子邮件正确，token错误
      get edit_password_reset_path('wrong token', email: user.email)
      assert_redirected_to root_url
      # both correct
      get edit_password_reset_path(user.reset_token, email: user.email)
      assert_template 'password_resets/edit'
      assert_select "input[name=email][type=hidden][value=?]", user.email
      # 密码与密码确认不同
      patch password_reset_path(user.reset_token), params: {
        email: user.email,
        user: {password: "foobaz",
              password_confirmation: "barquux"}
      }
      assert_select 'div#error_explanation'
      # 空密码值
      patch password_reset_path(user.reset_token), params: {
        email: user.email,
        user: {
          password: "",
          password_confirmation: ""
        }
      }
      assert_select 'div#error_explanation'
      # both valid
      patch password_reset_path(user.reset_token), params: {
        email: user.email,
        user: {
          password: "foobaz",
          password_confirmation: "foobaz"
        }
      }
      assert is_logged_in?
      assert_not flash.empty?
      assert_redirected_to user
      assert_equal nil, user.reload.reset_digest
  end

  test "expired token" do
    get new_password_reset_url
    post password_resets_path, params: { password_reset: {
      email: @user.email
      }}
    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@user.reset_token), params: {
      email: @user.email,
      user: { password: "foobar",
              password_confirmation: "foobar"
       }
     }
    assert_response :redirect
    follow_redirect!
    assert_match /expired/i, response.body
  end


end
