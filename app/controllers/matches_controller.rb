class MatchesController < ApplicationController
  before_action :set_match, only: %i[ show edit update destroy ]

  def index
    @matches = Match.all
    # __method__ returns the current method being called https://apidock.com/ruby/Kernel/__method__
    set_options(__method__)
    handle_index_response
  end

  def show
    # @participants = Player.with_league_stats(league_id: @match.league.id).includes(:participations).order("total_score DESC, first_name ASC")
    @participations = @match.participations.includes(:participatable).order(:score)
  end

  def new
    @match = Match.new
    set_options(__method__)
  end

  def edit
    set_options(__method__)
  end

  # def create
  #   @match = Match.new(match_params.except(:participants, :scores))

  #   if @match.save
  #     match_saved = true
  #     scores = match_params[:scores]
  #     match_params[:participants].each_with_index do |p, index|
  #       @match.participations.create!(score: scores[index], participatable_id: p.to_i, participatable_type: "Player")
  #     end
  #   end

  #   if match_saved
  #     flash[:success] = "Match was successfully created."
  #     redirect_to matches_path
  #   else
  #     set_options(:new)
  #     render :new, status: :unprocessable_entity
  #   end
  # end
  def create
    @match = Match.new(match_params)

    if @match.save
      flash[:success] = "Match was successfully created."
      redirect_to matches_path
    else
      set_options(:new)
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @match.update(match_params_for_update)
    flash[:success] = "Match was successfully updated."
    redirect_to matches_path
    else
      set_options(:edit)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @match.destroy!
    flash[:success] = "Match was successfully destroyed."
    redirect_to matches_path
  end

  private
    def set_match
      # @match = Match.find(params.expect(:id))
      @match = Match.includes(:participations).find(params[:id])
    end

    def set_options(method)
      @league_options = League.order_by_created_at.map { |league| [ league.full_name, league.id ] }
      @leagues = League.order_by_created_at
      case method
      when :new
        @players = Player.all
        @date = Time.zone.today
      when :edit
        @players = Player.all
        @date = @match.date
        @score_hash = @match.participations.index_by(&:participatable_id).transform_values(&:score)
        # {23=>10, 24=>5, 25=>0} key is participatable id, value is score
        @match_players = @match.players
      end
    end

    def handle_index_response
      respond_to do |format|
        format.html
        format.turbo_stream
      end
    end

    def base_match_params
      params.require(:match).permit(
        :date,
        :league_id,
        participations_attributes: [ :score, :participatable_id ]
      )
    end

    def match_params
      base = base_match_params
      type = League.find_by(id: base[:league_id]).participant_type.capitalize
      base[:participations_attributes].each do |_, attrs|
        attrs[:participatable_type] = type
      end

      base
    end

    def match_params_for_update
      params.require(:match).permit(
        :date,
        participations_attributes: [ :id, :score, :participatable_id ]
      )
    end
  # def match_params
  #   params.expect(match: [ :date, :league_id, participants: [], scores: [] ])
  # end
end
