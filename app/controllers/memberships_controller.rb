class MembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_league
  before_action :ensure_admin!

  def create
    player = Player.find(params[:player_id])
    if player && !@league.memberships.include?(player)
      @league.memberships.create!(player: player, league: @league)
      flash.now[:success] = "#{player.full_name} added to league."
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @league }
      end
    else
      redirect_to @league, alert: "Player not found or already a league member."
    end
  end

  def destroy
    membership = Membership.all.find(params[:id])
    player = membership.player
    membership.destroy
    flash.now[:success] = "#{player.full_name} removed from league."
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @league }
    end
  end

  def player_section
    @addable_players = current_user.players.exclude(@league.players).order_by_name
    @addable_players_array = @addable_players.map { |p| [ p.full_name, p.id ] }
    @memberships = @league.memberships.order_by_player_name
  end

  private

  def set_league
    @league = League.find(params[:league_id])
  end

  def ensure_admin!
    unless @league.league_auths.find_by(user: current_user)&.admin?
      flash[:warning] = I18n.t(:forbidden)
      redirect_to new_user_session_path
    end
  end
end
