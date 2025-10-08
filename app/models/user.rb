class User < ApplicationRecord
  has_secure_password
  validates :password, length: { minimum: 8 }, allow_nil: true
  validates :email, presence: true, uniqueness: true

  has_many :decks, dependent: :destroy
  has_many :password_resets, dependent: :destroy
end
