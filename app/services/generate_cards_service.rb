require 'net/http'
require 'json'
require 'base64'

module Gemini
  class GenerateCardsService
    def initialize(user:, file:, deck_name: nil)
      @user = user
      @file = file
      @deck_name = deck_name || "Novo deck gerado pela IA"
    end

    def call
      # Cria o deck
      @deck = @user.decks.create!(name: @deck_name)

      # Salva o arquivo temporariamente
      file_path = Rails.root.join("tmp", @file.original_filename)
      File.open(file_path, "wb") { |f| f.write(@file.read) }

      file_base64 = Base64.strict_encode64(File.read(file_path))

      # Chama a IA
      response = send_to_gemini(file_base64, @file.content_type)
      ai_text = response.dig("candidates", 0, "content", "parts", 0, "text")

      json_text = ai_text.match(/\[.*\]/m)&.to_s
      raise "Resposta inválida da IA" unless json_text

      cards_data = JSON.parse(json_text)
      created_cards = create_cards(cards_data)

      { success: true, deck: @deck, cards: created_cards }
    rescue => e
      # Remove deck se algo falhar
      @deck.destroy if @deck&.persisted?
      { success: false, error: e.message }
    ensure
      File.delete(file_path) if file_path && File.exist?(file_path)
    end

    private

    def send_to_gemini(file_base64, mime_type)
      uri = URI("https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=#{ENV['GEMINI_API_KEY']}")
      headers = { "Content-Type" => "application/json" }

      body = {
        contents: [
          {
            parts: [
              {
                text: <<~PROMPT
                  Gere flashcards de estudo a partir do conteúdo enviado.
                  Retorne **somente** JSON válido, no formato:
                  [
                    { "term": "termo 1", "definition": "definição do termo 1" },
                    { "term": "termo 2", "definition": "definição do termo 2" }
                  ]
                  Gere entre 5 e 15 cards em português.
                PROMPT
              },
              {
                inline_data: {
                  mime_type: mime_type,
                  data: file_base64
                }
              }
            ]
          }
        ]
      }

      response = Net::HTTP.post(uri, body.to_json, headers)
      JSON.parse(response.body)
    end

    def create_cards(cards_data)
      cards_data.map do |card|
        @deck.cards.create!(
          term: card["term"],
          definition: card["definition"]
        )
      end
    end
  end
end
