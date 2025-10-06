require 'httparty'

class GeminiService
  include HTTParty
  base_uri 'https://generativelanguage.googleapis.com/v1beta'

  def initialize
    @api_key = ENV['GEMINI_API_KEY']
  end

  def generate_flashcards(prompt)
    model = "gemini-1.5-flash"

    body = {
      contents: [
        { role: "user", parts: [{ text: prompt }] }
      ]
    }

    response = self.class.post(
      "/models/#{model}:generateContent?key=#{@api_key}",
      headers: { "Content-Type" => "application/json" },
      body: body.to_json
    )

    if response.success?
      response.parsed_response.dig("candidates", 0, "content", "parts", 0, "text")
    else
      raise "Erro na API Gemini: #{response.code} - #{response.body}"
    end
  end
end
