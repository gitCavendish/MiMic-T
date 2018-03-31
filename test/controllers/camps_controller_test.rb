require 'test_helper'

class CampsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @camp = camps(:one)
  end

  test "should get index" do
    get camps_url
    assert_response :success
  end

  test "should get new" do
    get new_camp_url
    assert_response :success
  end

  test "should create camp" do
    assert_difference('Camp.count') do
      post camps_url, params: { camp: { intro: @camp.intro, picture: @camp.picture, time: @camp.time, title: @camp.title, user_id: @camp.user_id, venue: @camp.venue } }
    end

    assert_redirected_to camp_url(Camp.last)
  end

  test "should show camp" do
    get camp_url(@camp)
    assert_response :success
  end

  test "should get edit" do
    get edit_camp_url(@camp)
    assert_response :success
  end

  test "should update camp" do
    patch camp_url(@camp), params: { camp: { intro: @camp.intro, picture: @camp.picture, time: @camp.time, title: @camp.title, user_id: @camp.user_id, venue: @camp.venue } }
    assert_redirected_to camp_url(@camp)
  end

  test "should destroy camp" do
    assert_difference('Camp.count', -1) do
      delete camp_url(@camp)
    end

    assert_redirected_to camps_url
  end
end
