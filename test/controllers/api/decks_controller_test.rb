require "test_helper"

class Api::DecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      full_name: "John Doe",
      email: "test@example.com",
      password: "password"
    )

    @user.decks.create name: "Deck"
  end

  test "should get index" do
    get api_decks_url, headers: authenticated_user(@user)
    assert_response :success

    response_array = JSON.parse response.body
    assert_equal 1, response_array.length
  end

  test "should post create" do
    post api_decks_url, params: { name: "Foo bar!" },
      headers: authenticated_user(@user),
      as: :json
    assert_response :created
  end
end
