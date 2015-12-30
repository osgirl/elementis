require "demo_page"

module Elementis
  class TestCase < Minitest::Test
    def self.inherited(klass)
      super

      include Capybara::DSL

      klass.send :define_method, :setup do
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

      klass.send :define_method, :teardown do
        Elementis.reset!
        Capybara.reset_sessions!
      end
    end
  end
end
