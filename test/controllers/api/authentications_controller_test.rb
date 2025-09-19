require "test_helper"

class Api::AuthenticationsControllerTest < ActionDispatch::IntegrationTest
  test "should get google_oauth2" do
    get api_authentications_google_oauth2_url
    assert_response :success
  end
end
