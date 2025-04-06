class SignupsController < ApplicationController
  allow_unauthenticated_access only: %w[new create]
  invisible_captcha only: %w[create], timestamp_enabled: false

  def new
    @signup = Signup.new
  end

  def create
    @signup = Signup.new(signup_params)

    if user = @signup.save
      start_new_session_for user

      redirect_to root_url
    else
      redirect_to new_signups_path
    end
  end

  private

  def signup_params
    # NOTE: new syntax, see PR: https://github.com/rails/rails/pull/51674
    params.expect(signup: [ :email_address, :password, :terms ])
  end
end
