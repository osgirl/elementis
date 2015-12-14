module Elementis
  module CapybaraExtensions
    module ScriptArgs
      refine Capybara::Session do
        def execute_script(script, *args)
          @touched = true
          driver.execute_script(script, *args)
        end
      end

      refine Capybara::Selenium::Driver do
        def execute_script(script, *args)
          args.map! { |e| e.kind_of?(Capybara::Node::Element) ? e.native : e }
          browser.execute_script(script, *args)
        end
      end
    end
  end
end
