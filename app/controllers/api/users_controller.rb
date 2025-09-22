class Api::UsersController < ApplicationController
  def create
    user = ::User.new(user_params)

    if user.save
      jwt = issue_jwt_token(user)
      render json: { user: UserSerializer.new(user), jwt: jwt }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :email, :password, :password_confirmation)
  end
end
