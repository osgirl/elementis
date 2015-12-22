require_relative "test_helper"

class StoreDemoQA < Elementis::Page
  def initialize
    @url = "/"
    @blog_text = Element.new(:xpath, "//*[contains(text(),'Blog Post')]")
    @buy_now_btn = Element.new(:css, ".buynow")
    @search = Element.new(:css, "input.search", visible: :all)
    @main_nav = Element.new(:css, "#main-nav", visible: :all)
    @my_account = Element.new("#account")
    @dne = Element.new(".dne", visible: :all)
    @hidden = Element.new("#lightbox_slideshow", visible: :all)
  end

  def wait_for_elements
    puts("Inheritied page #{__method__}")
    @blog_text.wait_until(5).visible
    @buy_now_btn.wait_until(5).visible
  end
end

class App
  def demo_page
    StoreDemoQA.new
  end
end

class TestPage < Minitest::Test
  include Capybara::DSL

  def setup
    Elementis.configure do |config|
      config.element_timeout = 2
      config.highlight_verifications = true
      config.highlight_duration = 0.2
      config.log_level = :fatal
    end

    Capybara.current_driver = Capybara.javascript_driver
    Capybara.app_host = "http://store.demoqa.com"

    @app = App.new
    @page = @app.demo_page
    @page.load
  end

  def teardown
    Elementis.reset!
    Capybara.reset_sessions!
  end

  should "timeout waiting for page to load" do
    Elementis.configure do |config|
      config.page_load_timeout = 0.5
    end

    assert_raises(Timeout::Error) { visit "localhost" }
  end

  should "load a page" do
    visit "/products-page/product-category/ipads/"
    assert_equal "/products-page/product-category/ipads/", page.current_path
  end

  should "pass capybara element methods using method_missing" do
    assert_equal "nav", @page.main_nav.tag_name
    assert page.has_link?("Your Account")
    assert page.has_content?("Product Category")
  end

  should "click on link text using click_on" do
    click_on "Your Account"
    assert_equal "/products-page/your-account/", page.current_path
  end

  should "set text using =" do
    assert @page.search.text = "Marley"
  end

  should "send text to element using sendkeys" do
    assert @page.search.send_keys "Byte Me"
    assert @page.search.send_keys "Byte Me"
  end

  should "verify element extension presence is true" do
    assert_equal true, @page.main_nav.present?, "should be present"
  end

  should "verify element extension presence is false" do
    assert_equal false, @page.dne.present?, "should not be present"
  end

  should "wait until present and return element" do
    assert_equal @page.main_nav.element, @page.main_nav.wait_until.present
    assert_equal @page.blog_text.element, @page.blog_text.wait_until.present
  end

  should "wait until not present and return nil" do
    assert_equal nil, @page.dne.wait_until.not.present
  end

  should "wait until visible and return element" do
    assert_equal @page.main_nav.element, @page.main_nav.wait_until.visible
    assert_equal @page.blog_text.element, @page.blog_text.wait_until.visible
  end

  should "wait until not visible element and return element" do
    assert_equal @page.hidden.element, @page.hidden.wait_until.not.visible
  end

  should "wait until visible and return text with user specified timeout" do
    assert_equal "Buy Now", @page.buy_now_btn.wait_until(1).visible.text
  end

  should "be visible" do
    assert_equal true, @page.main_nav.visible?
  end

  should "raise error with user specified timeout: element is visible, verifying not" do
    assert_raises(Capybara::ElementNotFound) { @page.main_nav.wait_until(1).not.visible }
  end

  should "find an element within a element" do
    assert @page.main_nav.find_in_children("input.search").set "Jah live"
  end

  should "use DSL for element within an element" do
    assert @page.main_nav.find_in_children("input.search").wait_until(1).visible.set "Yey-ah"
  end

  should "fail to find a valid element not a child" do
    assert_raises(Capybara::ElementNotFound) { @page.main_nav.find_in_children("#logo") }
  end

  should "fail to find a unknown element within an element" do
    assert_raises(Capybara::ElementNotFound) { @page.main_nav.find_in_children("#invalid") }
  end

  should "execute javascript to hide element" do
    @page.my_account.hide
    assert @page.my_account.verify.not.visible
    assert_raises(Capybara::ElementNotFound) { @page.my_account.verify.visible }
  end

  should "execute javascript to show element" do
    @page.my_account.hide
    assert @page.my_account.verify.not.visible
    @page.my_account.show
    assert @page.my_account.verify.visible
    assert_raises(Capybara::ElementNotFound) { @page.my_account.verify.not.visible }
  end

  should "execute javascript on an element" do
    page.execute_script("arguments[0].scrollIntoView(); return;", find(:xpath, "//*[text()='Your Account']"))
  end
end
