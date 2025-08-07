class PlayersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_player, only: %i[ show edit update destroy league_filter ]

  def index
    @players = Player.all
    handle_index_response
  end

  def show
    @league_options = [ [ "All", nil ] ] +
                        @player.leagues.order_by_created_at.distinct.map { |league| [ league.full_name, league.id ] }
    @participations = @player.participations.
                              merge(Match.order_by_date).
                              includes(match: [ :league ]).
                              then { |chain| session.dig(:player_league_ids, @player.id.to_s).present? ? chain.where(matches: { league_id: session.dig(:player_league_ids, @player.id.to_s) }) : chain }
  end

  def league_filter
    session[:player_league_ids]&.delete(@player.id.to_s)
    if (league_id = params[:player_league_id].presence) # when 'All' is selected', nil is passed and the conditional is false so the session[:player_league_ids] for the player does not get set (remains nil).
      session[:player_league_ids] ||= {}
      session[:player_league_ids][@player.id.to_s] = league_id.to_i
    end
    redirect_to @player
  end

  # GET /players/new
  def new
    @player = Player.new
  end

  # GET /players/1/edit
  def edit
  end

  def create
    @player = Player.new(player_params)

    if @player.save
      flash[:success] = "Player was successfully created."
      redirect_to players_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @player.update(player_params)
      flash[:success] = "Player was successfully updated."
      redirect_to players_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @player.destroy!
    flash[:success] = "Player was successfully destroyed."
    redirect_to players_path
  end

  private
    def set_player
      @player = Player.find(params.expect(:id))
    end

    def set_league
      @league = League.find_by(id: params[:league_id]) || "All"
    end

    def handle_index_response
      respond_to do |format|
        format.html
        format.turbo_stream
      end
    end

    def player_params
      params.expect(player: [ :first_name, :last_name ])
    end
end
