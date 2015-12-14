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

    def disabled
      @element.element(wait: @timeout, disabled: @should_be)
    end

    def visible
      visibility = @should_be ? true : :hidden
      @element.element(wait: @timeout, visible: visibility)
    end

    def present
      present = @element.present?

      raise Capybara::ExpectationNotMet if !present && @should_be
      raise Capybara::ExpectationNotMet if present && !@should_be

      @should_be ? @element.element : nil
    end

    # TODO:
    def selected
      raise NotImplementedError
    end

    # TODO:
    def has_text(text)
      raise NotImplementedError
    end

    # TODO:
    def has_value(value)
      raise NotImplementedError
    end

    # TODO:
    def has_attribute(attribute, value)
      raise NotImplementedError
    end

    # TODO:
    def has_css(css, value)
      raise NotImplementedError
    end
  end
end