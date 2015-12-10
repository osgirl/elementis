require_relative 'test_helper'

class StoreDemoQA < Elementis::Page
  attr_reader :blog_text, :buy_now_btn

  def initialize
    @url = "/"
    @blog_text = Element.new(:xpath, "//*[contains(text(),'Blog Post')]")
    @buy_now_btn = Element.new(:css, "button[name=btnG]")
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
    @app = App.new
    Capybara.current_driver = Capybara.javascript_driver
    Capybara.app_host = "http://store.demoqa.com"
  end

  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  should "load the page" do
    puts "Loading the demo page"
    @page = @app.demo_page.load
    puts "Demo page loaded"
    # @page.wait_for_elements
    @page.buy_now_btn.click

    assert page.has_link?("Home"), "Fucking-A"
    assert page.has_content?("Product Category"), "Fucking-B"
    page.execute_script("")
  end

  should "test element presence" do
    @app.demo_page.load
    puts "Main nav present = #{Element.new(:css, '#main-nav').present?}"
  end
end