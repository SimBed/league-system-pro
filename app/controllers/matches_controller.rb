class MatchesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_league, only: [ :new ]
  before_action :set_match, only: %i[ show edit update destroy ]

  # def index
  #   handle_selection
  #   # __method__ returns the current method being called https://apidock.com/ruby/Kernel/__method__
  #   set_options(__method__)
  #   handle_index_response
  # end

  def show
    # @participants = Player.with_league_stats(league_id: @match.league.id).includes(:participations).order("total_score DESC, first_name ASC")
    @participations = @match.participations.includes(:participant).order(score: :desc)
  end

  def new
    set_options(__method__)
    @match = @league.matches.build
    @league.participants_per_match.times { @match.participations.build }
  end

  def edit
    set_options(__method__)
  end

  def create
    @match = Match.new(match_params)
    if @match.save
      flash[:success] = "Match was successfully created."
      redirect_to @match.league
    else
      set_options(:new)
      # render edit to retain inputs (rather than new which will lose the inputs and start league selection...dynamic form process again)
      render :edit, status: :unprocessable_entity
    end
  end

  def update
    if @match.update(match_params_for_update)
    flash[:success] = "Match was successfully updated."
    redirect_to @match.league
    else
      set_options(:edit)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @match.destroy!
    flash[:success] = "Match was successfully destroyed."
    redirect_to @match.league
  end

  # def filter
  #   clear_session(:league_id)
  #   session[:league_id] = params[:league_id] || session[:league_id]
  #   redirect_to matches_path
  # end

  private
    def set_match
      # @match = Match.find(params.expect(:id))
      @match = Match.includes(:participations).find(params[:id])
    end

    def require_league
      # This shouldnt happen, but this approach avoids 'breaking out a of a turbo-stream' if it does
      return unless params[:league_id].blank?

      render turbo_stream: turbo_stream.replace("new_match") {
        helpers.content_tag(:div, class: "p-4 text-center text-danger") do
          flash[:alert] = "Please select a league first."
          helpers.link_to "League somehow got deselected. Please go back to leagues and reselect.", leagues_path, data: { turbo: "false" }, class: "text-danger"
        end
      }
    end

    def set_options(method)
      @leagues = current_user.leagues.order_by_created_at
      @league_options = @leagues.map { |league| [ league.full_name, league.id ] }
      # @league = League.find(session[:league_id].to_i)
      case method
      when :new
        # @players = current_user.players.order_by_name
        @league = League.find(params[:league_id].to_i)
        @players = @league.players.order_by_name
        @date = Time.zone.today
      when :edit
        # @match.players would go through the participations association (not what we want)
        @players = @match.league.players.order_by_name
        @date = @match.date
        @score_hash = @match.participations.index_by(&:participant_id).transform_values(&:score)
        # {23=>10, 24=>5, 25=>0} key is participant id, value is score
      end
    end

    # def handle_selection
    #   session[:league_id] = session[:league_id] || current_user.leagues.minimum(:id)
    #   # check session[:league_id] still authorised
    #   @matches = if session[:league_id].nil? || !current_user.leagues.pluck(:id).include?(session[:league_id].to_i)
    #     []
    #   else
    #     Match.where(league_id: session[:league_id].to_i).order_by_date.includes(:league)
    #   end
    # end

    def handle_index_response
      respond_to do |format|
        format.html
        format.turbo_stream
      end
    end

    def match_params
      params.require(:match).permit(
        :date,
        :league_id,
        participations_attributes: [ :score, :participant_id, :participant_type ]
      )
    end

    # def base_match_params
    #   params.require(:match).permit(
    #     :date,
    #     :league_id,
    #     participations_attributes: [ :score, :participant_id ]
    #   )
    # end

    # def match_params
    #   base = base_match_params
    #   # type = League.find_by(id: base[:league_id]).participant_type.capitalize
    #   type = League.find_by(id: base[:league_id]).participant_type.capitalize
    #   base[:participations_attributes].each do |_, attrs|
    #     attrs[:participant_type] = type
    #   end

    #   base
    # end

    def match_params_for_update
      params.require(:match).permit(
        :date,
        participations_attributes: [ :id, :score, :participant_id ]
      )
    end
end
