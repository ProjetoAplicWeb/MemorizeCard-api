class UserMailer < ApplicationMailer
  def password_reset_email(user, code)
    @user = user
    @code = code
    mail(to: @user.email, subject: "Sua senha do Memorize")
  end
end
