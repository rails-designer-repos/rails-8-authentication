class MagicSignupsController < ApplicationController
  allow_unauthenticated_access only: %w[new create]
  invisible_captcha only: %w[create], timestamp_enabled: false

  def new
    @signup = MagicSignin.new
  end

  def create
    MagicSignin.new(signup_params).save

    redirect_to new_magic_signup_path
  end

  private

  def signup_params
    params.expect(magic_signin: [ :email_address ])
  end
end
