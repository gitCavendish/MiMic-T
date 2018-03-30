require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    get contact_path
    assert_select "title", full_title("Contact")
  end

  test "signup link" do
    get root_path
    assert_select "a[href=?]", signup_path
    get signup_path
    assert_template "users/new"
    assert_select "title", full_title("Sign up")
  end
end
