module Api
  class GenerateCardsIaController < ApplicationController
    before_action :authenticate_user!

    # POST /api/generate_cards_ia
    # Recebe file (PDF/PNG) e opcionalmente deck_name
    def create
      file = params[:file]
      return render json: { error: "Arquivo não enviado" }, status: :bad_request unless file

      deck_name = params[:deck_name]

      service = Gemini::GenerateCardsService.new(
        user: current_user,
        file: file,
        deck_name: deck_name
      )

      result = service.call

      if result[:success]
        render json: { deck: result[:deck], cards: result[:cards] }, status: :created
      else
        render json: { error: result[:error] }, status: :unprocessable_entity
      end
    end
  end
end
