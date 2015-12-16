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

      fail Capybara::ExpectationNotMet if !present && @should_be
      fail Capybara::ExpectationNotMet if present && !@should_be

      @should_be ? @element.element : nil
    end

    # TODO: selected
    def selected
      fail NotImplementedError
    end

    # TODO: has_text
    def text(_text)
      fail NotImplementedError
    end

    # TODO: has_value
    def value(_value)
      fail NotImplementedError
    end

    # TODO: has_attribute
    def attribute(_attribute, _value)
      fail NotImplementedError
    end

    # TODO: has_css
    def css(_css, _value)
      fail NotImplementedError
    end
  end
end
