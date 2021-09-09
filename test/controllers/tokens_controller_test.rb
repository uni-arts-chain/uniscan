require "test_helper"

class TokensControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get tokens_index_url
    assert_response :success
  end
end
