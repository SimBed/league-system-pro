class LeaguesController < ApplicationController
  include SortHelper
  helper_method :sort_column, :sort_direction
  before_action :authenticate_user!
  before_action :set_league, only: %i[ show edit update destroy ]
  before_action :authorize_league_access, only: [ :show, :edit, :update, :destroy ]

  def index
    @leagues = current_user.leagues.order_by_created_at.includes(:matches)
    @league_leaders = Player.with_league_stats.group_by(&:league_id).transform_values do |players|
      players.max_by(&:total_score)
    end
    handle_index_response
  end

  def show
    # @participants = Player.with_league_stats(league_id: @league.id).order("total_score DESC, first_name ASC")
    @sort_direction = sort_direction
    @sort_column = sort_column
    # e.g. [ "wins" ]
    tie_breakers = SORT_TIE_BREAKERS[sort_column] || SORT_TIE_BREAKERS[:default]
    # e.g. [ total_score ASC, wins ASC, first_name ASC ]
    order_columns = [ "#{sort_column} #{sort_direction}" ] +
                    tie_breakers.map { |col| "#{col} #{sort_direction}" } +
                    [ "first_name ASC" ]
    @participants = Player.with_league_stats(league_id: @league.id).order(order_columns.join(", "))
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

    def sort_column
      # Sanitizing the search options, so only items specified in the list can get through
      %w[score wins].include?(params[:sort]) ? params[:sort] : "total_score"
    end

    def sort_direction
      # additional code provides robust sanitisation of what goes into the order clause
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end

    def get_form_cancel_link
      @show_cancel = params[:link_from] == "player_show" ? false : true

      @form_cancel_link = @match_id ? matches_path : leagues_path
    end

    def authorize_league_access
      unless @league.users.include?(current_user)
        redirect_to root_path, alert: "You are not authorized to view this league."
      end
    end
end
