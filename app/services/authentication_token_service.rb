class AuthenticationTokenService
  require "json_web_token"

  def self.generate_for(user)
    payload = { user_id: user.id }
    JsonWebToken.encode(payload)
  end
end
