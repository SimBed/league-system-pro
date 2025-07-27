module ApplicationHelper
  def clear_session(*args)
    args.each do |session_key|
      session[session_key] = nil
    end
  end
end
