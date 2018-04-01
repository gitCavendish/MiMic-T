require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:caven)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_url
    assert_select 'div.pagination'
    #无效提交post
    assert_no_difference "Micropost.count" do
      post microposts_path, params: {micropost: { content: ""}}
    end
    #有效提交post
    content = "This micropost really ties the room together"
    assert_difference "Micropost.count", +1 do
      post microposts_path, params: {micropost: { content: content}}
    end

    # assert assigns(:micropost).picture?
    follow_redirect!
    assert_match content, response.body
    #删除micropost
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # 访问其他用户show页面（没有delete链接）
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end

  test "micropost sidebar count" do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body
    # 另一个没有发布micropost的用户
    other_user = users(:malory)
    log_in_as(other_user)
    get root_url
    assert_match "0 micropost", response.body
    other_user.microposts.create!(content: "A micropost")
    get root_url
    assert_match "1 micropost", response.body
  end



end
