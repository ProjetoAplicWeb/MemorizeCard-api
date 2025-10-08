class PasswordReset < ApplicationRecord
  MAX_ATTEMPTS = 5

  belongs_to :user

  def expired?
    expires_at < Time.current
  end

  def max_attempts_reached?
    attempts >= MAX_ATTEMPTS
  end
end
