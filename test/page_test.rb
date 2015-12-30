require_relative "test_helper"

class StoreDemoQA < Elementis::Page
  element :blog_text, ".footer_blog p"
  element :buy_now_btn, :css, ".buynow"
  element :search, :css, "input.search", visible: :all
  element :main_nav, :css, "#main-nav", visible: :all
  element :my_account, "#account"
  element :my_account_link, "#account a"
  element :logo, "#logo"
  element :dne, ".dne", visible: :all
  element :hidden, "#lightbox_slideshow", visible: :all

  def initialize
    @url = "/"
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

# rubocop:disable ClassLength
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

  # Presence

  should "verify element extension presence is true" do
    assert_equal true, @page.main_nav.present?, "should be present"
  end

  should "raise error when present and shouldn't be" do
    err = assert_raises(Capybara::ExpectationNotMet) { @page.blog_text.wait_until.not.present }
    assert_match(/not present/, err.message)
  end

  should "raise error when not present and should be" do
    err = assert_raises(Capybara::ExpectationNotMet) { @page.dne.wait_until.present }
    assert_match(/is present/, err.message)
  end

  should "verify element extension presence is false" do
    assert_equal false, @page.dne.present?, "should not be present"
  end

  should "verify element is enabled" do
    assert_equal true, @page.blog_text.enabled?
  end

  should "verify element not enabled" do
    page.execute_script("arguments[0].setAttribute('disabled', 'disabled'); return;", @page.search.element)
    assert_equal false, @page.search.enabled?
  end

  should "verify element extension presence is false" do
    assert_equal true, @page.blog_text.present?, "should be present"
  end
  
  should "wait until present and return element" do
    assert @page.main_nav.wait_until.present.instance_of?(Elementis::Element)
  end

  should "wait until not present and return nil" do
    assert_equal nil, @page.dne.wait_until.not.present
  end

  # visibility

  should "raise error when visible and shouldn't be" do
    err = assert_raises(Capybara::ExpectationNotMet) { @page.blog_text.wait_until.not.visible }
    assert_match(/not visible/, err.message)
  end

  should "raise error when not visible and should be" do
    err = assert_raises(Capybara::ExpectationNotMet) { @page.dne.wait_until.visible }
    assert_match(/is visible/, err.message)
  end

  should "wait until visible and return element" do
    assert @page.main_nav.wait_until.visible.instance_of?(Elementis::Element)
    assert @page.blog_text.wait_until.visible.instance_of?(Elementis::Element)
  end

  should "wait until not visible element and return element" do
    assert @page.hidden.wait_until.not.visible.instance_of?(Elementis::Element)
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

  # disabled

  should "raise error when disabled and shouldn't be" do
    page.execute_script("arguments[0].setAttribute('disabled', 'disabled'); return;", @page.search.element)
    err = assert_raises(Capybara::ExpectationNotMet) { @page.search.wait_until.not.disabled }
    assert_match(/not disabled/, err.message)
  end

  should "raise error when not disabled and should be" do
    err = assert_raises(Capybara::ExpectationNotMet) { @page.search.wait_until.disabled }
    assert_match(/is disabled/, err.message)
  end

  should "return disabled element" do
    page.execute_script("arguments[0].setAttribute('disabled', 'disabled'); return;", @page.search.element)
    assert @page.search.wait_until.disabled.instance_of?(Elementis::Element)
  end

  should "return enabled element" do
    assert @page.search.wait_until.not.disabled.instance_of?(Elementis::Element)
  end

  # Text
  should "verify element has text" do
    assert @page.my_account.wait_until.text("My Account")
  end

  should "verify element does not have text" do
    assert @page.my_account.wait_until.not.text("Buy It Now")
  end

  should "verify text element verification returns element" do
    assert @page.my_account.wait_until.text("My Account").instance_of?(Elementis::Element)
  end

  should "raise text verification error when element does not have text specified" do
    err = assert_raises(Capybara::ExpectationNotMet) { @page.my_account.wait_until.text("Home") }
    assert_match(/has text/, err.message)
  end

  should "raise text verification error when verifying element should not have text" do
    err = assert_raises(Capybara::ExpectationNotMet) { @page.my_account.wait_until.not.text("My Account") }
    assert_match(/does not have text/, err.message)
  end

  # Attribute

  should "verify element has attribute" do
    assert @page.my_account_link.wait_until.attribute("class", "account_icon")
  end

  should "verify element does not have attribute" do
    assert @page.my_account_link.wait_until.not.attribute("class", "doable")
  end

  should "verify element attribute verification returns element" do
    assert @page.my_account_link.wait_until.attribute("class", "account_icon").instance_of?(Elementis::Element)
  end

  should "raise verification error when element does not have attribute specified" do
    err = assert_raises(Capybara::ExpectationNotMet) { @page.my_account_link.wait_until.attribute("class", "Ding") }
    assert_match(/has attribute/, err.message)
  end

  should "raise verification error when verifying element should not have attribute" do
    err = assert_raises(Capybara::ExpectationNotMet) \
            { @page.my_account_link.wait_until.not.attribute("class", "account_icon") }
    assert_match(/does not have attribute/, err.message)
  end

  # Element children

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

  should "verify element is stale" do
    logo = @page.logo.verify.visible
    page.execute_script("document.getElementById('logo').remove()")
    assert_equal true, logo.send(:stale?)
  end
end
