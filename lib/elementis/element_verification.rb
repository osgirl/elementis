require "wait"
include Elementis

module Elementis
  class ElementVerification
    #
    # @param [Element] element
    # @param [Integer] timeout
    # @param [Boolean] fail_test - fail test right away or not
    # @param [Boolean] should - verify true or not
    #
    def initialize(element, timeout, fail_test = true, should = true)
      @element = element # Elementis element
      @timeout = timeout
      @should = should
      @fail_test = fail_test
    end

    def not
      ElementVerification.new(@element, @timeout, @fail_test, false)
    end

    def disabled
      disabled = @element.element(wait: @timeout).disabled?

      fail Capybara::ExpectationNotMet, "Failed to verify #{@element} is disabled" if !disabled && @should
      fail Capybara::ExpectationNotMet, "Failed to verify #{@element} not disabled" if disabled && !@should

      @element
    end

    def visible
      begin
        visibility = @should ? true : :hidden
        @element.element(wait: @timeout, visible: visibility)
      rescue Capybara::ElementNotFound
        raise Capybara::ExpectationNotMet, "Failed to verify #{@element} is visible" if visibility == true
        raise Capybara::ExpectationNotMet, "Failed to verify #{@element} not visible" if visibility == :hidden
      end

      @element
    end

    def present
      present = @element.present?

      fail Capybara::ExpectationNotMet, "Failed to verify #{@element} is present" if !present && @should
      fail Capybara::ExpectationNotMet, "Failed to verify #{@element} not present" if present && !@should

      @should ? @element : nil
    end

    def selected
      wait = ::Wait.new(timeout: @timeout)

      if @should
        begin
          wait.until { @element.element.selected? == true }
        rescue StandardError
          raise Capybara::ExpectationNotMet, "Failed to verify #{@element} is selected"
        end
      else
        begin
          wait.until { @element.element.selected? == false }
        rescue StandardError
          raise Capybara::ExpectationNotMet, "Failed to verify #{@element} is not selected"
        end
      end

      @element
    end

    def text(text)
      if @should && @element.element.has_no_text?(text, wait: @timeout)
        fail Capybara::ExpectationNotMet, "Failed to verify #{@element} has text '#{text}'"
      end

      if !@should && @element.element.has_text?(text, wait: @timeout)
        fail Capybara::ExpectationNotMet, "Failed to verify #{@element} does not have text '#{text}'"
      end

      @element
    end

    def attribute(attribute, value)
      wait = ::Wait.new(timeout: @timeout)

      if @should
        begin
          wait.until { @element.element[attribute] == value }
        rescue StandardError
          raise Capybara::ExpectationNotMet,
                "Failed to verify #{@element} has attribute '#{attribute}' with value '#{value}'"
        end
      else
        begin
          wait.until { @element.element[attribute] != value }
        rescue StandardError
          raise Capybara::ExpectationNotMet,
                "Failed to verify #{@element} does not have attribute '#{attribute}' with value '#{value}'"
        end
      end

      @element
    end
  end
end
