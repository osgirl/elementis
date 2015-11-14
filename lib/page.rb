require 'element'
require 'elements'

module Elementis
  class Page
    include Capybara::DSL

    attr_accessor :url

    def initialize
      wait_for_elements
    end

    # Override this to have your page object wait for certain elements to be displayed before continuing
    def wait_for_elements
    end


    def page
      @page ||= Capybara.current_session
    end

    def load
      visit @url unless @url.nil?
      self
    end
  end
end
