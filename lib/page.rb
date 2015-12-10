require 'element'
require 'elements'

module Elementis
  class Page
    include Capybara::DSL

    # Override this to have your page object wait for certain elements to be displayed before continuing
    def wait_for_elements
      puts("Base Page #{__method__}")
    end


    def page
      @page ||= Capybara.current_session
    end

    def load
      puts "url = #{@url}"
      visit @url unless @url.nil?
      wait_for_ajax
      self
    end

    def wait_for_ajax
      Timeout.timeout(Elementis.config.page_load_timeout) do
        loop until page.evaluate_script('jQuery.active').zero?
      end
    end
  end
end
