require "test_helper"

class Api::CardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      full_name: "John Doe",
      email: "test@example.com",
      password: "password"
    )

    @deck = @user.decks.create name: "Deck"
    @card = @deck.cards.create term: "Card", definition: "Definition"
  end

  test "should get index" do
    get "/api/decks/#{@deck.id}/cards", headers: authenticated_user(@user)
    assert_response :success

    response_array = JSON.parse response.body
    assert_equal 1, response_array.length
  end

  test "should post create" do
    body = { term: "Foo", definition: "Bar" }
    post "/api/decks/#{@deck.id}/cards",
      params: body,
      headers: authenticated_user(@user),
      as: :json
    assert_response :success
  end

  test "should patch update" do
    body = { definition: "Definition v2" }
    patch "/api/cards/#{@card.id}",
      params: body,
      headers: authenticated_user(@user),
      as: :json
    assert_response :success
  end

  test "should delete destroy" do
    delete "/api/cards/#{@card.id}", headers: authenticated_user(@user)
    assert_response :success
  end
end
