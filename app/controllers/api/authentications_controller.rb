class Api::AuthenticationsController < ApplicationController
  def google_oauth2
    id_token = params[:token]

    begin
      validator = GoogleIDToken::Validator.new
      payload = validator.check(id_token, ENV["GOOGLE_CLIENT_ID"])

      user = ::User.find_or_create_by(email: payload["email"]) do |u|
        u.full_name = payload["name"]
        u.password = SecureRandom.hex(16)
      end

      if user.persisted?
        jwt = issue_jwt_token(user)
        render json: { user: UserSerializer.new(user), jwt: jwt }, status: :ok
      else
        render json: { error: "Failed to create or find user" }, status: :unprocessable_entity
      end
    rescue GoogleIDToken::ValidationError => e
      render json: { error: "Invalid Google ID Token: #{e.message}" }, status: :unauthorized
    end
  end
end
