module Elementis
  module CapybaraExtensions
    Capybara::Session.class_exec do
      def execute_script(script, *args)
        @touched = true
        driver.execute_script(script, *args)
      end

      visit_method = self.instance_method(:visit)

      define_method(:visit) do |visit_url|
        visit_method.bind(self).call(visit_url)

        return unless Elementis.javascript_driver?

        Timeout.timeout(Elementis.config.page_load_timeout) do
          loop until
            driver.evaluate_script("document.readyState").eql?("complete") &&
            driver.evaluate_script("jQuery.active").zero?
        end
      end
    end

    Capybara::Selenium::Driver.class_exec do
      def execute_script(script, *args)
        args.map! { |e| e.is_a?(Capybara::Node::Element) ? e.native : e }
        browser.execute_script(script, *args)
      end
    end
  end
end
