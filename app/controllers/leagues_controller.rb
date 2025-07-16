class LeaguesController < ApplicationController
  before_action :set_league, only: %i[ show edit update destroy ]

  def index
    @leagues = League.includes(:matches)
    @league_leaders = Player.with_league_stats.group_by(&:league_id).transform_values do |players|
      players.max_by(&:total_score)
    end
  end

  def show
    @participants = Player.with_scores_for(@league).order("total_score DESC, first_name ASC")
    @match_id = params[:match_id]
    get_form_cancel_link
  end

  def new
    @league = League.new
  end

  def edit
  end

  def create
    @league = League.new(league_params)

    respond_to do |format|
      if @league.save
        format.html { redirect_to @league, notice: "League was successfully created." }
        format.json { render :show, status: :created, location: @league }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @league.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @league.update(league_params)
        format.html { redirect_to @league, notice: "League was successfully updated." }
        format.json { render :show, status: :ok, location: @league }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @league.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @league.destroy!

    respond_to do |format|
      format.html { redirect_to leagues_path, status: :see_other, notice: "League was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_league
      @league = League.find(params.expect(:id))
    end

    def league_params
      params.expect(league: [ :name, :season, :match_participants, :participant_type ])
    end

    def get_form_cancel_link
      @show_cancel = params[:link_from] == "player_show" ? false : true

      @form_cancel_link = @match_id ? matches_path : leagues_path
    end
end
