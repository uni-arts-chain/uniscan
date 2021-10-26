require "test_helper"

class CollectionsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    collection = collections(:one)
    get collection_url(collection)
    assert_response :success
  end
end
