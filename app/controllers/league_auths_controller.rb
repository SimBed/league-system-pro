class LeagueAuthsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_league
  before_action :ensure_admin!

  def create
    user = User.find_by(email: params[:email])
    if user && !@league.users.include?(user)
      @league_auths = @league.league_auths
      @league_auths.create!(user: user, role: :member)
      flash.now[:success] = "Authorisation for #{user.email} added to league."
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @league }
      end
    else
      redirect_to @league, alert: "User not found or already authorised."
    end
  end

  def destroy
    auth = @league.league_auths.find(params[:id])
    # @league_auths = @league.league_auths
    user = auth.user
    auth.destroy
    flash.now[:success] =  "User authorisation for #{user.email} removed from league."
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @league }
    end
  end

  def user_section
    @league_auths = @league.league_auths
  end

  private

  def set_league
    @league = League.find(params[:league_id])
  end

  def ensure_admin!
    unless @league.league_auths.find_by(user: current_user)&.admin?
      flash[:warning] = I18n.t(:forbidden)
    end
  end
end
