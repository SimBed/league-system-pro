class NavbarPresenter < BasePresenter
  def initialize(user_signed_in = false, request_path = nil)
    @user_signed_in = user_signed_in
    @request_path = request_path
  end

  def nav_item_text(text, url)
    return nil unless @user_signed_in

    anchor_class = [ "nav-link", ("active" if @request_path == url) ].compact.join(" ")
    tag.li class: "nav-item" do
      tag.a text, href: url, class: anchor_class
    end
  end
end
