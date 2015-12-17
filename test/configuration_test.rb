require "test_helper"

class ElementisConfiguration < Minitest::Test
  def setup
    Elementis.reset!
  end

  should "default page_load_timeout" do
    assert_equal Elementis.config.page_load_timeout, 15
  end

  should "set page_load_timeout" do
    Elementis.configure do |config|
      config.page_load_timeout = 30
    end

    assert_equal Elementis.config.page_load_timeout, 30
  end

  should "default element wait timeout" do
    assert_equal Elementis.config.element_timeout, 5
  end

  should "set element wait timeout" do
    Elementis.configure do |config|
      config.element_timeout = 2
    end

    assert_equal Elementis.config.element_timeout, 2
  end

  should "default log_level" do
    assert_equal Elementis.config.log_level, :fatal
  end

  should "set log_level" do
    Elementis.configure do |config|
      config.log_level = :info
    end

    assert_equal Elementis.config.log_level, :info
  end

  should "default highlight_verifications" do
    assert_equal Elementis.config.highlight_verifications, false
  end

  should "set highlight_verifications" do
    Elementis.configure do |config|
      config.highlight_verifications = true
    end

    assert_equal Elementis.config.highlight_verifications, true
  end

  should "default highlight_duration" do
    assert_equal Elementis.config.highlight_duration, 0.100
  end

  should "set highlight_duration" do
    Elementis.configure do |config|
      config.highlight_duration = 0.3
    end

    assert_equal Elementis.config.highlight_duration, 0.3
  end

  should "reset the configuration" do
    Elementis.configure do |config|
      config.highlight_verifications = true
      config.highlight_duration = 0.3
      config.log_level = :debug
      config.element_timeout = 40
      config.page_load_timeout = 60
    end

    Elementis.reset!

    assert_equal Elementis.config.page_load_timeout, 15
    assert_equal Elementis.config.element_timeout, 5
    assert_equal Elementis.config.log_level, :fatal
    assert_equal Elementis.config.highlight_verifications, false
    assert_equal Elementis.config.highlight_duration, 0.100
  end
end
