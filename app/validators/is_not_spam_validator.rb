class IsNotSpamValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, email_address)
    return if email_address.blank?

    if spam? email_address
      record.errors.add(attribute, options[:message] || "appears suspicious")
    end
  end

  private

  MAXIMUM_DOTS = 3

  def spam?(email_address)
    local_part, domain = email_address.split("@", 2)

    disposable?(domain) || excessive_dots_in?(local_part)
  end

  def disposable?(domain) = disposable_email_providers.include?(domain)

  # make sure to copy the list of disposable emails providers from:
  # https://github.com/disposable-email-domains/disposable-email-domains
  #
  def disposable_email_providers = File.read("config/disposable_email_providers.txt").split("\n")

  def excessive_dots_in?(local_part) = local_part.count(".") >= MAXIMUM_DOTS
end
