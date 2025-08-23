class ApplicationController < ActionController::Base
  include ApplicationHelper
  impersonates :user

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def after_sign_in_path_for(resource)
    leagues_path
  end

  # def require_admin
  #   redirect_to root_path, alert: "Not authorized" unless current_user.admin?
  # end

  def admin_user
    return if current_user.admin?

    flash[:warning] = I18n.t(:forbidden)
    redirect_to root_path
  end
end
