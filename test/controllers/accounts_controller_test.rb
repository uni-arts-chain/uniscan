require "test_helper"

class AccountsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    account = accounts(:one)
    get account_url(account)
    assert_response :success
  end
end
