class LeagueAuthsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_league
  before_action :ensure_admin!

  def create
    user = User.find_by(email: params[:email])
    if user && !@league.users.include?(user)
      @league.league_auths.create!(user: user, role: :member)
      redirect_to @league, notice: "Authorisation for #{user.email} added to league."
    else
      redirect_to @league, alert: "User not found or already aauthorised."
    end
  end

  def destroy
    auth = @league.league_auths.find(params[:id])
    auth.destroy
    redirect_to @league, notice: "User authorisation removed from league."
  end

  private

  def set_league
    @league = League.find(params[:league_id])
  end

  def ensure_admin!
    unless @league.league_auths.find_by(user: current_user)&.admin?
      redirect_to root_path, alert: "Only admin can manage authorisations."
    end
  end
end
