module Elementis
  module CapybaraExtensions
    module ScriptArgs
      Capybara::Session.module_exec do
        def execute_script(script, *args)
          @touched = true
          driver.execute_script(script, *args)
        end
      end

      Capybara::Selenium::Driver.module_exec do
        def execute_script(script, *args)
          args.map! { |e| e.is_a?(Capybara::Node::Element) ? e.native : e }
          browser.execute_script(script, *args)
        end
      end
    end
  end
end
