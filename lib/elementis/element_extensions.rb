module Elementis
  module ElementExtensions
    using Elementis::CapybaraExtensions::ScriptArgs

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
      self.send("#{caller_locations(1,1)[0].label}_element") if Elementis.javascript_driver?
    end

    def highlight_element
      if Elementis.config.highlight_verifications
        original_border = page.execute_script("return arguments[0].style.border", @element)
        original_background = page.execute_script("return arguments[0].style.backgroundColor", @element)
        page.execute_script("arguments[0].style.border='3px solid red'; return;", @element)
        sleep Elementis.config.highlight_duration
        page.execute_script("arguments[0].style.border='" + original_border + "'; return;", @element)
        page.execute_script("arguments[0].style.backgroundColor='" + original_background + "'; return;", @element)
      end
    end

    def scroll_to_element
      page.execute_script("arguments[0].scrollIntoView(); return;", @element)
    end

    def hover_element
      page.execute_script("var evObj = document.createEvent('MouseEvents'); evObj.initMouseEvent(\"mouseover\",true, false, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null); arguments[0].dispatchEvent(evObj);", @element)
    end

    def unhover_element
      page.execute_script("var evObj = document.createEvent('MouseEvents'); evObj.initMouseEvent(\"mouseout\",true, false, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null); arguments[0].dispatchEvent(evObj);", @element)
    end

    def hide_element
      page.execute_script("arguments[0].style.visibility='hidden';return;", @element)
    end

    def show_element
      page.execute_script("arguments[0].style.visibility='visible';return;", @element)
    end
  end
end
