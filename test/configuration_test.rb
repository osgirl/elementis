require 'test_helper'

class ElementisConfiguration < Minitest::Test
  i_suck_and_my_tests_are_order_dependent!

  def teardown
    Elementis.reset
  end

  should 'default element wait timeout' do
    assert_equal Elementis.config.element_timeout, 5
  end

  should 'set element wait timeout' do
    Elementis.configure do |config|
      config.element_timeout = 2
    end

    assert_equal Elementis.config.element_timeout, 2
  end

  should 'default log_level' do
    assert_equal Elementis.config.log_level, :fatal
  end

  should 'set log_level' do
    Elementis.configure do |config|
      config.log_level = :info
    end

    assert_equal Elementis.config.log_level, :info
  end

  should 'default highlight_verifications' do
    assert_equal Elementis.config.highlight_verifications, false
  end

  should 'set highlight_verifications' do
    Elementis.configure do |config|
      config.highlight_verifications = true
    end

    assert_equal Elementis.config.highlight_verifications, true
  end

  should 'default highlight_duration' do
    assert_equal Elementis.config.highlight_duration, 0.100
  end

  should 'set highlight_duration' do
    Elementis.configure do |config|
      config.highlight_duration = 0.3
    end

    assert_equal Elementis.config.highlight_duration, 0.3
  end

  should 'default capybara_match' do
    assert_equal Elementis.config.capybara_match, :smart
  end

  should 'set capybara_match' do
    Elementis.configure do |config|
      config.capybara_match = :prefer_exact
    end

    assert_equal Elementis.config.capybara_match, :prefer_exact
  end

  should 'default capybara_exact' do
    assert_equal Elementis.config.capybara_exact, false
  end

  should 'set capybara_exact' do
    Elementis.configure do |config|
      config.capybara_exact = true
    end

    assert_equal Elementis.config.capybara_exact, true
  end

  should 'default capybara_ignore_hidden_elements' do
    assert_equal Elementis.config.capybara_ignore_hidden_elements, true
  end

  should 'set capybara_ignore_hidden_elements' do
    Elementis.configure do |config|
      config.capybara_ignore_hidden_elements = false
    end

    assert_equal Elementis.config.capybara_ignore_hidden_elements, false
  end

  should 'default capybara_visible_text_only' do
    assert_equal Elementis.config.capybara_visible_text_only, true
  end

  should 'set capybara_visible_text_only' do
    Elementis.configure do |config|
      config.capybara_visible_text_only = false
    end

    assert_equal Elementis.config.capybara_visible_text_only, false
  end

  should 'reset the configuration' do
    Elementis.reset

    assert_equal Elementis.config.element_timeout, 5
    assert_equal Elementis.config.log_level, :fatal
    assert_equal Elementis.config.highlight_verifications, false
    assert_equal Elementis.config.highlight_duration, 0.100
    assert_equal Elementis.config.capybara_match, :smart
    assert_equal Elementis.config.capybara_exact, false
    assert_equal Elementis.config.capybara_ignore_hidden_elements, true
    assert_equal Elementis.config.capybara_visible_text_only, true
  end

  should 'print the configuration' do
    Elementis.config.print_configuration
  end
end