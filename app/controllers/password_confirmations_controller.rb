class PasswordConfirmationsController < ApplicationController
  def new
  end

  def create
    if Current.user.authenticate(params[:current_password])
      session[:password_confirmed_at] = Time.current.to_i

      redirect_to(session.delete(:password_return_to) || root_path)
    else
      render :new, status: :unprocessable_entity
    end
  end
end
