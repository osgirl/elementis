class StoreDemoQA < Elementis::Page
  def initialize
    @url = "/"
    @blog_text = Element.new(".footer_blog p")
    @buy_now_btn = Element.new(:css, ".buynow")
    @search = Element.new(:css, "input.search", visible: :all)
    @main_nav = Element.new(:css, "#main-nav", visible: :all)
    @my_account = Element.new("#account")
    @my_account_link = Element.new("#account a")
    @logo = Element.new("#logo")
    @dne = Element.new(".dne", visible: :all)
    @hidden = Element.new("#lightbox_slideshow", visible: :all)
  end

  def wait_for_elements
    @blog_text.wait_until(5).visible
    @buy_now_btn.wait_until(5).visible
  end
end

class App
  def demo_page
    StoreDemoQA.new
  end
end
