class NavbarPresenter < BasePresenter
  def initialize(signed_in = false, request_path = nil)
    @signed_in = signed_in
    @request_path = request_path
  end

  def nav_item_text(text, url, authorised)
    return nil if !(authorised && @signed_in)

    anchor_class = [ "nav-link", ("active" if @request_path == url) ].compact.join(" ")
    tag.li class: "nav-item" do
      tag.a text, href: url, class: anchor_class
    end
  end
end
