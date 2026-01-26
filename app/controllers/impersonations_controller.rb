class ImpersonationsController < ApplicationController
  # TODO: make sure to “lock down this action”

  def create
    impersonate! User.find(params[:user_id])

    redirect_to root_path
  end

  def destroy
    unimpersonate!

    redirect_to root_path
  end
end
