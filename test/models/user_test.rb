require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "    "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = " "
    assert_not @user.valid?
  end

  test "name should not > 50 char" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email shoud not > 255 char" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w{user@example,com user_at_foo.org user.name@example. foo@bar_+baz.com}
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid."
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email in database should be lowercase" do
    @user.email = "ExMple@Example.com"
    @user.save
    assert_equal @user.email, "ExMple@Example.com".downcase
  end

  test "password should be present(not blank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, "")
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference "Micropost.count", -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user(active perspective)" do
    michael = users(:michael)
    archer = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end

  test "should follow and unfollow a user(passive perspective)" do
    michael = users(:michael)
    archer = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not archer.followers.include?(michael)
  end

  test "feed should have the right posts" do
    michael = users(:michael)
    archer = users(:archer)
    lana = users(:lana)
    # following 们发布的 posts
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    # user 自己发布的 posts
    michael.microposts.each do |self_post|
      assert michael.feed.include?(self_post)
    end
    # 未关注用户的 posts (应该不显示)
    archer.microposts.each do |unfollowed_post|
      assert_not michael.feed.include?(unfollowed_post)
    end
  end

# relationships.yml

  # one:
  #   follower: michael
  #   followed: lana
  #
  # two:
  #   follower: michael
  #   followed: malory
  #
  # three:
  #   follower: lana
  #   followed: michael
  #
  # four:
  #   follower: archer
  #   followed: michael
  #


end
