require_relative "test_helper"

class VerificationsTest < Elementis::TestCase
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
