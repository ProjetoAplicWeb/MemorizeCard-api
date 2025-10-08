class Api::PasswordController < ApplicationController
  def forgot
    email = forgot_params
    @user = User.find_by(email: email)

    unless @user
      head :ok
      return
    end

    PasswordReset.where(user: @user).destroy_all
    code = SecureRandom.random_number(10000).to_s.rjust(4, "0")

    @reset_record = PasswordReset.new(
      user: @user,
      token_hash: BCrypt::Password.create(code),
      expires_at: 10.minutes.from_now
    )

    if @reset_record.save
      UserMailer.password_reset_email(@user, code).deliver_now
      head :ok
    else
      render json: { errors: @reset_record.errors.full_messages }, status: :internal_server_error
    end
  end

  private

  def forgot_params
    params.require(:email)
  end
end
