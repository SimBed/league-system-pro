class PlayerAuthsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_player
  before_action :ensure_owner!

  def create
    user = User.find_by(email: params[:email])
    if user && !@player.users.include?(user)
      @player.player_auths.create!(user: user, role: :member)
      redirect_to @player, notice: "Authorisation for #{user.email} added to player."
    else
      redirect_to @player, alert: "User not found or already authorised."
    end
  end

  def destroy
    auth = @player.player_auths.find(params[:id])
    auth.destroy
    redirect_to @player, notice: "User authorisation removed from player."
  end

  private

  def set_player
    @player = Player.find(params[:player_id])
  end

  def ensure_owner!
    unless @player.player_auths.find_by(user: current_user)&.admin?
      flash[:warning] = I18n.t(:forbidden)
      redirect_to new_user_session_path
    end
  end
end
