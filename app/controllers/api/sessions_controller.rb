class Api::SessionsController < ApplicationController
  def create
    user = ::User.find_by("lower(email) = ?", params[:email].downcase)

    if user&.authenticate(params[:password])
      jwt = issue_jwt_token(user)
      render json: { user: UserSerializer.new(user), jwt: jwt }, status: :ok
    else
      render json: { error: "Email ou senha inválidos" }, status: :unauthorized
    end
  end
end
