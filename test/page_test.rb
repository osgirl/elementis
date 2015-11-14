require_relative 'test_helper'

class GooglePage < Elementis::Page
  attr_reader :search_entry, :search_btn

  def initialize
    @url = "http://www.google.com"
    @search_entry = Element.new(:css, "#lst-ib")
    @search_btn = Element.new(:css, "button[name=btnG")
  end

  def wait_for_elements

  end
end

class App
  def google_page
    GooglePage.new
  end
end

class TestPage < Minitest::Test
  include Capybara::DSL

  def setup
    @app = App.new
  end

  should "load the page" do
    @app.google_page.load
    @page = @app.google_page
    @page.search_entry.text = "Ding Dong"
    @page.search_btn.click
    # assert_page_has_content?("Ding Dong")
    # assert_page_has_content?("Urban Dictionary")
    assert page.has_content?("Ding Dong"), "Fucking-A"
    assert page_has_content?("Urban Dictionary"), "Fucking-B"
  end
end