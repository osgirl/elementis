
class StoreDemoQA < Elementis::Page
  page_url "/"

  element :blog_text, ".footer_blog p"
  element :buy_now_btn, :css, ".buynow"
  element :search, :css, "input.search"
  element :main_nav, :css, "#main-nav"
  element :my_account, "#account"
  element :my_account_link, "#account a"
  element :logo, "#logo"
  element :dne, ".dne", visible: :all
  element :hidden, "#lightbox_slideshow", visible: :all

  def wait_for_elements
    blog_text.wait_until(5).visible
    buy_now_btn.wait_until(5).visible
  end
end

class AccountPage < Elementis::Page
  page_url "/products-page/your-account/"
end

class App
  def demo_page
    StoreDemoQA.new
  end

  def account_page
    AccountPage.new
  end
end
