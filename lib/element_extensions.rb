# TODO: Fix execute_script
require "capybara_extensions/script_args"
include Elementis

module Elementis
  module ElementExtensions
    using ::CapybaraExtensions::ScriptArgs

    def highlight
      puts "Elementis.highlight_verifications = #{Elementis.config.highlight_verifications}"
      puts "Elementis.highlight_duration = #{Elementis.config.highlight_duration}"
      if Elementis.javascript_driver? && Elementis.config.highlight_verifications
          original_border = page.execute_script("return arguments[0].style.border", element)
        original_background = page.execute_script("return arguments[0].style.backgroundColor", element)
        page.execute_script("arguments[0].style.border='3px solid red'; return;", element)
        # page.execute_script("arguments[0].style.backgroundColor='lime'; return;", element)
        sleep Elementis.config.highlight_duration
        page.execute_script("arguments[0].style.border='" + original_border + "'; return;", element)
        page.execute_script("arguments[0].style.backgroundColor='" + original_background + "'; return;", element)
      end
    end

    def scroll_to
      page.execute_script("arguments[0].scrollIntoView(); return;", element)
    end

    def hover_over
      page.execute_script("var evObj = document.createEvent('MouseEvents'); evObj.initMouseEvent(\"mouseover\",true, false, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null); arguments[0].dispatchEvent(evObj);", element)
    end

    def hover_away
      page.execute_script("var evObj = document.createEvent('MouseEvents'); evObj.initMouseEvent(\"mouseout\",true, false, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null); arguments[0].dispatchEvent(evObj);", element)
    end

    def hide
      page.execute_script("arguments[0].style.visibility='hidden';return;", element)
    end

    def show
      page.execute_script("arguments[0].style.visibility='visible';return;", element)
    end
  end
end
