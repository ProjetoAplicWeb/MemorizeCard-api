class DecksController < ApplicationController
  def index
    @decks = Deck.includes(:cards).all
    render json: { data: @decks.as_json(include: :cards) }
  end

  def show
    @deck = Deck.includes(:cards).find params[:id]
    render json: { data: @deck.as_json(include: :cards) }
  end

  def create
    @deck = Deck.create name: deck_params

    if not @deck.save
      render json: { error: true }, status: :unprocessable_entity
    end

    render json: { data: @deck }
  end

  def update
    @deck = Deck.find params[:id]
    @deck.update name: deck_params

    head :ok
  end

  def destroy
    @deck = Deck.find params[:id]
    @deck.delete

    head :ok
  end

  private

  def deck_params
    params.expect([ :name ])
  end
end
