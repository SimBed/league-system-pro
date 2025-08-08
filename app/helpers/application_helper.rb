module ApplicationHelper
  def clear_session(*args)
    args.each do |session_key|
      session[session_key] = nil
    end
  end

  def sortable(column:, coltitle: nil, view: nil, default_direction: "desc", match_id: nil)
    coltitle ||= column.titleize
    # sort_colum, sort_direction are controller methods
    css_class = column == sort_column ? "current #{@sort_direction}" : "notcurrent"
    if column == sort_column && @sort_direction == default_direction
      direction = opp_direction(direction)
    end
    link_to coltitle, { sort: column, direction: direction, match_id: }, { class: css_class }
  end

  def opp_direction(direction)
    return "desc" if direction == "asc"

    "asc"
  end
end
