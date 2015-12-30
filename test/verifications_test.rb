require_relative "test_helper"

class VerificationsTest < Elementis::TestCase
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

  should "wait until present and return element" do
    assert @page.main_nav.wait_until.present.instance_of?(Elementis::Element)
  end

  should "wait until not present and return nil" do
    assert_equal nil, @page.dne.wait_until.not.present
  end

  should "raise error with user specified timeout: element is visible, verifying not" do
    assert_raises(Capybara::ElementNotFound) { @page.main_nav.wait_until(1).not.visible }
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

  # Disabled

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
end
