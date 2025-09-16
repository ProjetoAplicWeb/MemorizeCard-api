require "test_helper"

class DecksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get "/decks"
    assert_response :success
  end

  test "should post create" do
    post "/decks", params: { name: "Foo bar!" }, as: :json
    assert_response :success
  end
end
