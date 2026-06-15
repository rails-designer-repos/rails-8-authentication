class User::Subscriptions < Vault
  vault_attribute :product_emails_subscribed_at, :datetime

  # Add more subscription types as needed:
  # vault_attribute :marketing_emails_subscribed_at, :datetime
  # vault_attribute :weekly_digest_subscribed_at, :datetime
end
