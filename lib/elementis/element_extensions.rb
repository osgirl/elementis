module Elementis
  module ElementExtensions
    def highlight
      perform
    end

    def scroll_to
      perform
    end

    def hover
      perform
    end

    def unhover
      perform
    end

    def hide
      perform
    end

    def show
      perform
    end

    private

    # Guard actual calls, if not running Capybara Javascript driver
    def perform
      self.send("#{caller_locations(1, 1)[0].label}_element") if Elementis.javascript_driver?
    end

    # rubocop:disable LineLength
    def highlight_element
      return unless Elementis.config.highlight_verifications
      return unless @element

      original_border = Capybara.current_session.execute_script("return arguments[0].style.border", @element)
      original_background = Capybara.current_session.execute_script("return arguments[0].style.backgroundColor", @element)
      Capybara.current_session.execute_script("arguments[0].style.border='3px solid red'; return;", @element)
      sleep Elementis.config.highlight_duration
      Capybara.current_session.execute_script("arguments[0].style.border='#{original_border}'; return;", @element)
      Capybara.current_session.execute_script("arguments[0].style.backgroundColor='#{original_background}'; return;", @element)
    end

    def scroll_to_element
      Capybara.current_session.execute_script("arguments[0].scrollIntoView(); return;", element)
    end

    def hover_element
      script = <<-SCRIPT
        var evObj = document.createEvent('MouseEvents');
        evObj.initMouseEvent(\"mouseover\",true, false, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
        arguments[0].dispatchEvent(evObj);
      SCRIPT
      Capybara.current_session.execute_script(script, element)
    end

    def unhover_element
      script = <<-SCRIPT
        var evObj = document.createEvent('MouseEvents');
        evObj.initMouseEvent(\"mouseout\",true, false, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
        arguments[0].dispatchEvent(evObj);
      SCRIPT
      Capybara.current_session.execute_script(script, element)
    end

    def hide_element
      Capybara.current_session.execute_script("arguments[0].style.visibility='hidden';return;", element)
    end

    def show_element
      Capybara.current_session.execute_script("arguments[0].style.visibility='visible';return;", element)
    end
  end
end
