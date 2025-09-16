class CardsController < ApplicationController
  def index
    @deck = Deck.find params[:id]
    @cards = @deck.cards.all
    render json: { data: @cards }
  end

  def create
    @deck = Deck.find params[:id]
    @card = @deck.cards.create(card_params)
    render json: { data: @card }, status: :created
  end

  def destroy
    @deck = Deck.find params[:deck_id]
    @card = @deck.cards.find params[:card_id]
    @card.delete

    head :ok
  end

  def done
    @card = Card.find params[:id]
    @card.update last_difficulty: card_done_params[:difficulty], last_view: Date.today

    head :ok
  end

  private

  def card_params
    params.permit([ :term, :definition ])
  end

  def card_done_params
    params.permit([ :difficulty ])
  end
end
