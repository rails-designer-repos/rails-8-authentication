class MagicSessionsController < ApplicationController
  allow_unauthenticated_access only: %w[show new create]
  before_action :set_user_by_token, only: %i[ show ]

  def show
    start_new_session_for @user

    redirect_to root_path
  end

  def new
    @signin = MagicSignin.new
  end

  def create
    MagicSignin.new(signin_params).save

    redirect_to new_magic_session_path
  end

  private

    def signin_params
      params.expect(magic_signin: [ :email_address ])
    end

    def set_user_by_token
      @user = User.find_by_token_for(:signin, params[:token])
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect_to new_magic_signup_path, alert: "Link is invalid or has expired."
    end
end
