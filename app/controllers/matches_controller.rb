class MatchesController < ApplicationController
  before_action :set_match, only: %i[ show edit update destroy ]

  def index
    @matches = Match.all
    set_options
  end

  def show
    @participants = Player.with_scores_for(@match.league).order("total_score DESC, first_name ASC")
  end

  def new
    @match = Match.new
    set_options
  end

  def edit
    set_options
  end

  def create
    @match = Match.new(match_params.except(:participants, :scores))

    if @match.save
      match_saved = true
      scores = match_params[:scores]
      match_params[:participants].each_with_index do |p, index|
        @match.participations.create!(score: scores[index], participatable_id: p.to_i, participatable_type: "Player")
      end
    end

    respond_to do |format|
      if match_saved
        format.html { redirect_to @match, notice: "Match was successfully created." }
        format.json { render :show, status: :created, location: @match }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @match.update(match_params)
        format.html { redirect_to @match, notice: "Match was successfully updated." }
        format.json { render :show, status: :ok, location: @match }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @match.destroy!

    respond_to do |format|
      format.html { redirect_to matches_path, status: :see_other, notice: "Match was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_match
      @match = Match.find(params.expect(:id))
    end

  def set_options
    @league_options = League.order_by_created_at.map { |league| [ league.full_name, league.id ] }
    @players = Player.all
  end

    def match_params
      params.expect(match: [ :date, :league_id, participants: [], scores: [] ])
    end
end
