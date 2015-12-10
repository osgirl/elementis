include Elementis

module Elementis
  class ElementVerification
    #
    # @param [Element] element
    # @param [Integer] timeout
    # @param [Boolean] fail_test - fail test right away or not
    # @param [Boolean] should_be - verify true or not
    #
    def initialize(element, timeout, fail_test = true, should_be = true)
      @element = element # Elementis element
      @timeout = timeout
      @should_be = should_be
      @fail_test = fail_test
    end

    def not
      ElementVerification.new(@element, @timeout, @fail_test, false)
    end

    def text(text)
      should_have_text = truthy
      element_text = @element.text
      if @element.present?
        $verification_passes += 1
      else
        Log.error("Cannot determine element text.  Element is not present.")
      end

      if should_have_text
        fail_message = "Element should contain text (#{text}), but does not."
        pass_message = "contains text (#{text})."
      else
        fail_message = "Element should not contain text (#{text}), but does."
        pass_message = "does not contain text (#{text}).  Actual text is: (#{element_text})."
      end

      wait = Selenium::WebDriver::Wait.new :timeout => @timeout, :interval => 1
      begin
        wait.until do
          element_contains_text = element_text.eql?(text)
          if should_have_text && element_contains_text
            puts("Confirming text (#{text}) is within element...")
            ElementExtensions.highlight(@element) if Elementis.config.highlight_verifications
            log_success(pass_message)
          elsif !should_have_text && !element_contains_text
            puts("Confirming text (#{text}) is NOT within element...")
            ElementExtensions.highlight(@element) if Elementis.config.highlight_verifications
            log_success(pass_message)
          else
            log_issue("#{fail_message}  Element's text is: (#{element_text}).")
          end
        end
        @element
      end
    end

    def disabled
      @element.element(wait: @timeout, disabled: @should_be)
    end

    def visible
      @element.element(wait: @timeout, visible: @should_be)
    end

    def present
      @element.present?
    end

    # TODO:
    def selected
      raise NotImplementedError
    end

    # TODO:
    def having_value(value)
      raise NotImplementedError
    end

    # TODO:
    def having_attribute(attribute, value)
      raise NotImplementedError
    end

    # TODO:
    def having_css(css, value)
      raise NotImplementedError
    end


    private

    def log_issue(message)
      if @fail_test
        Log.error("#{message} ['#{@element.name}' (By:(#{@element.by} => '#{@element.locator}'))].")
        $fail_test_instantly = true
        Kernel.fail(message)
      else
        Log.error("#{message} ['#{@element.name}' (By:(#{@element.by} => '#{@element.locator}'))].")
        $fail_test_at_end = true
      end
    end

    def log_success(pass_message)
      $verification_passes += 1
      puts("Verified: '#{@element.name}' (By:(#{@element.by} => '#{@element.locator}')) #{pass_message}")
    end
  end
end