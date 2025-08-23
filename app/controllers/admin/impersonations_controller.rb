class Admin::ImpersonationsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_user, only: :create

  def create
    user = User.find(params[:id])
    # authorize user, :impersonate?  # Pundit authorization

    impersonate_user(user)
    flash[:success] = "Now viewing as #{user.email}"
    redirect_to leagues_path
  end

  def destroy
    stop_impersonating_user
    flash[:success] = "Stopped viewing as other user"
    redirect_to users_path
  end
end
