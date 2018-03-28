require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title, "caven xu mimic-T"
    assert_equal full_title("Help"), "Help | caven xu mimic-T"
  end
end
