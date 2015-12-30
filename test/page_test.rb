require_relative "test_helper"

class TestPage < Elementis::TestCase
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

  should "be visible" do
    assert_equal true, @page.main_nav.visible?
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

  should "verify element is stale" do
    logo = @page.logo.verify.visible
    page.execute_script("document.getElementById('logo').remove()")
    assert_equal true, logo.send(:stale?)
  end
end
