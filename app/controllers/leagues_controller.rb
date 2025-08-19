class LeaguesController < ApplicationController
  include SortHelper
  helper_method :sort_column, :sort_direction
  before_action :authenticate_user!
  before_action :set_league, only: [ :show, :edit, :update, :destroy ]
  before_action :authorize_league_access, only: [ :show, :edit, :update, :destroy ]

  def index
    @leagues = current_user.leagues.order_by_created_at.includes(:matches)
    @league_leaders = Player.with_league_stats.group_by(&:league_id).transform_values do |players|
      players.max_by(&:total_score)
    end
    handle_response
  end

  def show
    filter
    @sort_column, @sort_direction = set_sort_params # e.g. [ "total_score", 'desc' ]
    @participants = Player.with_league_stats(league_id: @league.id).order(order_sql_array.join(", "))
    @match_id = params[:match_id]
    get_form_cancel_link
    @frame_id = @match_id ? "show_league_for_match_#{@match_id}" : "league_#{@league.id}"
    # @addable_players = current_user.players.exclude(@league.players).order_by_name
    # @leagues = current_user.leagues.order_by_created_at
    # @league_options = @leagues.map { |league| [ league.full_name, league.id ] }
    # @matches = Match.where(league: @league).order_by_date.includes(:league)
    @matches = @league.matches.order_by_date.includes(:league)
    handle_response
  end

  def new
    @league = League.new
  end

  def edit
  end

  def create
    @league = League.new(league_params)
    @league.creator = current_user
    if @league.save
      current_user.league_auths.create!(league: @league, role: :admin)
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

    def filter
      clear_session(:league_id)
      session[:league_id] = params[:id] || session[:league_id]
    end

    def set_league
      @league = League.find(params.expect(:id))
    end

    def handle_response
      respond_to do |format|
        format.turbo_stream
        format.html
      end
    end

    def league_params
      params.expect(league: [ :name, :season, :participants_per_match, :participant_type ])
    end

    def sort_column
      # Sanitizing the search options, so only items specified in the list can get through
      %w[total_score wins].include?(params[:sort]) ? params[:sort] : "total_score"
    end

    def sort_direction
      # additional code provides robust sanitisation of what goes into the order clause
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end

    def set_sort_params
      [ sort_column, sort_direction ]
    end

    def order_sql_array
      tie_breakers = SORT_TIE_BREAKERS[@sort_column] || SORT_TIE_BREAKERS[:default]
      # e.g. [ total_score ASC, wins ASC, first_name ASC ]
      [ "#{sort_column} #{sort_direction}" ] +
      tie_breakers.map { |col| "#{col} #{sort_direction}" } +
      [ "first_name ASC" ]
    end

    def get_form_cancel_link
      @show_cancel = params[:link_from] == "player_show" ? false : true

      @form_cancel_link = @match_id ? matches_path : leagues_path
    end

    def authorize_league_access
      unless @league.users.include?(current_user)
        redirect_to root_path, alert: "You are not authorized to take this action."
      end
    end
end
