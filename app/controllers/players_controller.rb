class PlayersController < ApplicationController
  before_action :set_player, only: %i[ show edit update destroy ]

  def index
    @players = Player.all
    handle_index_response
  end

  def show
    @leagues = [ [ "All", nil, { "data-showurl" => player_path(@player) } ] ] +
                @player.leagues.map { |l| [ l.full_name, l.id, { "data-showurl" => player_url(@player.id, { league_id: l.id }) } ] }
    @participations = @player.participations.includes(match: [ :league ])
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

    def handle_index_response
      respond_to do |format|
        format.html
        format.turbo_stream
      end
    end

    def player_params
      params.expect(player: [ :first_name, :last_name, :team_id ])
    end
end
