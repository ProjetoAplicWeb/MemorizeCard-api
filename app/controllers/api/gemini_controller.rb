class Ai::CardsController < ApplicationController
  def create
    prompt = params[:prompt] || "Crie 5 flashcards de estudo sobre Ruby on Rails"
    gemini = GeminiService.new
    output = gemini.generate_flashcards(prompt)

    render json: { result: output }
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
