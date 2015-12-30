module Elementis
  class Page
    include Capybara::DSL

    attr_accessor :url

    def page
      @page ||= Capybara.current_session
    end

    def load
      visit url unless url.nil?
      wait_for_page_load
      self
    end

    def wait_for_page_load
      return unless Elementis.javascript_driver?

      Timeout.timeout(Elementis.config.page_load_timeout) do
        loop until page_loaded? && jquery_loaded?
      end
    end

    def method_missing(method_name, *args, &block)
      vars = self.instance_variables
      if vars.include? "@#{method_name}".to_sym
        instance_variable_get "@#{method_name}"
      else
        super
      end
    end

    private

    def jquery_loaded?
      page.evaluate_script("jQuery.active").zero?
    end

    def page_loaded?
      page.evaluate_script("document.readyState").eql?("complete")
    end
  end
end
