module PasswordConfirmation
  extend ActiveSupport::Concern

  class_methods do
    # Requires password confirmation for specified actions. Password remains valid for the given duration.
    # every: duration the confirmation remains valid (default: 10.minutes)
    # options: standard before_action options like :only and :except
    #
    def confirm_password(every: 10.minutes, **)
      before_action -> { require_password(every) }, **
    end
  end

  private

  def require_password(expiry_time)
    return if password_confirmed_within?(expiry_time)

    store_return_path

    redirect_to new_password_confirmation_path
  end

  def password_confirmed_within?(expiry)
    return false unless session[:password_confirmed_at]

    Time.at(session[:password_confirmed_at]).after?(expiry.ago)
  end

  def store_return_path
    session[:password_return_to] = request.fullpath
  end
end
