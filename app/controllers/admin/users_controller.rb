class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_user
  def index
    @users = User.order(:email)
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User was successfully removed"
    redirect_to users_path
  end
end
