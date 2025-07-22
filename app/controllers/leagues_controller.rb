class LeaguesController < ApplicationController
  before_action :set_league, only: %i[ show edit update destroy ]

  def index
    @leagues = League.includes(:matches)
    @league_leaders = Player.with_league_stats.group_by(&:league_id).transform_values do |players|
      players.max_by(&:total_score)
    end
    handle_index_response
  end

  def show
    @participants = Player.with_league_stats(league_id: @league.id).order("total_score DESC, first_name ASC")
    @match_id = params[:match_id]
    get_form_cancel_link
    @frame_id = @match_id ? "show_league_for_match_#{@match_id}" : "league_#{@league.id}"
  end

  def new
    @league = League.new
  end

  def edit
  end

  def create
    @league = League.new(league_params)
    if @league.save
      flash[:success] = "League was successfully created."
      redirect_to leagues_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @league.update(league_params)
      flash[:success] = "League was successfully updated."
      redirect_to leagues_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @league.destroy!
    flash[:success] = "League was successfully destroyed."
    redirect_to leagues_path
  end

  private
    def set_league
      @league = League.find(params.expect(:id))
    end

    def handle_index_response
      respond_to do |format|
        format.html
        format.turbo_stream
      end
    end

    def league_params
      params.expect(league: [ :name, :season, :participants_per_match, :participant_type ])
    end

    def get_form_cancel_link
      @show_cancel = params[:link_from] == "player_show" ? false : true

      @form_cancel_link = @match_id ? matches_path : leagues_path
    end
end
