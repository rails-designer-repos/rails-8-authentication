class User < ApplicationRecord
  vault :subscriptions
  has_secure_password
  has_many :sessions, dependent: :destroy

  belongs_to :workspace

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  generates_token_for :signin, expires_in: 5.minutes
end
