require "test_helper"

class TokensControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get tokens_url
    assert_response :success
  end
end
