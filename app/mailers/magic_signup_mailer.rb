class MagicSignupMailer < ApplicationMailer
  def magic_link(user)
    @user = user
    mail to: @user.email_address
  end
end
