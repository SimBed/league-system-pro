class PagesController < ApplicationController
  def home
    path = user_signed_in? ? matches_path : new_user_session_path
    redirect_to path
  end
end
