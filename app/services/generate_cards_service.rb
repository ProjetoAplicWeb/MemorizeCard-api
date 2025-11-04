# app/services/groq/generate_cards_service.rb
require 'net/http'
require 'json'
require 'base64'
require 'securerandom'

begin
  require 'pdf/reader'
rescue LoadError
  # pdf-reader não instalado — fallback para enviar base64
end

class GenerateCardsService
    ALLOWED_MIME_TYPES = %w[
      application/pdf
      text/plain
      application/msword
      application/vnd.openxmlformats-officedocument.wordprocessingml.document
    ].freeze

    def initialize(user:, file:, deck_name: nil)
      @user = user
      @file = file
      @deck_name = deck_name.presence || "Novo deck gerado pela IA"
      @tmp_path = nil
    end

    def call
      validate!

      # Cria o deck
      @deck = @user.decks.create!(name: @deck_name)

      save_temp_file
      content = extract_text_or_base64

      ai_response = send_to_groq(content[:data], content[:is_text])
      ai_text = parse_groq_response(ai_response)

      cards_data = extract_json_array(ai_text)
      raise "Resposta inválida da IA (JSON ausente ou incorreto)" unless cards_data.is_a?(Array)

      created_cards = create_cards(cards_data)

      { success: true, deck: @deck, cards: created_cards }
    rescue => e
      @deck.destroy if @deck&.persisted?
      { success: false, error: e.message }
    ensure
      cleanup_tmp_file
    end

    private

    def validate!
      raise "Usuário inválido" unless @user
      raise "Arquivo inválido" unless @file.respond_to?(:original_filename)

      unless ALLOWED_MIME_TYPES.include?(@file.content_type)
        raise "Tipo de arquivo não suportado (#{@file.content_type}). Apenas PDF / texto / docx são aceitos."
      end
    end

    def save_temp_file
      filename = "#{SecureRandom.uuid}_#{@file.original_filename}"
      @tmp_path = Rails.root.join("tmp", filename)
      File.open(@tmp_path, "wb") { |f| f.write(@file.read) }
    end

    def extract_text_or_base64
      if @file.content_type == "application/pdf" && defined?(PDF::Reader)
        begin
          text = extract_text_from_pdf(@tmp_path)
          if text.strip.length > 50
            return { data: text, is_text: true }
          end
        rescue => e
          Rails.logger.warn("Erro ao extrair texto do PDF: #{e.message}. Usando base64.")
        end
      end

      file_base64 = Base64.strict_encode64(File.read(@tmp_path))
      { data: file_base64, is_text: false }
    end

    def extract_text_from_pdf(path)
      text = []
      PDF::Reader.open(path) do |reader|
        reader.pages.each { |page| text << page.text }
      end
      text.join("\n")
    end

    def send_to_groq(data, is_text)
      uri = URI("https://api.groq.com/openai/v1/chat/completions")
      headers = {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{ENV['GROQ_API_KEY']}"
      }

      prompt_base = <<~PROMPT
        Você é um assistente que transforma conteúdo em flashcards de estudo.

        Gere **somente um JSON válido**, no formato:
        [
          { "term": "termo 1", "definition": "definição do termo 1" },
          { "term": "termo 2", "definition": "definição do termo 2" }
        ]

        - Gere entre 5 e 15 cards em português.
        - Termos curtos e diretos.
        - Definições claras e concisas (até ~300 caracteres).
      PROMPT

      user_content = if is_text
                       "Conteúdo extraído do arquivo:\n\n#{data}"
                     else
                       "Arquivo em base64 (#{@file.content_type}). Interprete e gere flashcards:\n\n#{data}"
                     end

      body = {
        model: "llama-3.1-70b-versatile", # Pode trocar para outro modelo Groq compatível
        messages: [
          { role: "system", content: prompt_base },
          { role: "user", content: user_content }
        ],
        temperature: 0.5,
        max_tokens: 800
      }

      response = Net::HTTP.post(uri, body.to_json, headers)
      raise "Erro HTTP #{response.code}: #{response.body}" unless response.is_a?(Net::HTTPSuccess)

      JSON.parse(response.body)
    end

    def parse_groq_response(response_json)
      text = response_json.dig("choices", 0, "message", "content")
      raise "Resposta vazia da IA" if text.blank?
      text
    end

    def extract_json_array(text)
      json_match = text.match(/(\[.*\])/m)&.captures&.first
      raise "Não foi possível encontrar JSON na resposta da IA" unless json_match
      JSON.parse(json_match)
    end

    def create_cards(cards_data)
      cards_data.map do |card|
        @deck.cards.create!(
          term: card["term"].to_s.strip,
          definition: card["definition"].to_s.strip
        )
      end
    end

    def cleanup_tmp_file
      File.delete(@tmp_path) if @tmp_path && File.exist?(@tmp_path)
    end
  end
