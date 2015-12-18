module Elementis
  class Element
    include Capybara::DSL
    include Elementis::ElementExtensions

    def initialize(*args)
      @element = nil
      @args = args
    end

    def element(opts = {})
      if @element.nil? || stale?
        unless opts.empty?
          requested_opts = @args.extract_options!
          requested_opts.merge!(opts)
          @args += [requested_opts]
        end

        Log.info "Finding element #{self}"
        @element = find(*@args)
      end

      self.highlight
      @element
    end

    # Find an element within this element
    def find_in_children(*args)
      child = nil
      within(element) do
        child = self.class.new(*args)
        child.element
      end

      child
    end

    # TODO: list of verifications? And addition of callback or accessor/clear
    def verify(timeout = nil)
      timeout = Elementis.config.element_timeout if timeout.nil?
      ElementVerification.new(self, timeout)
    end

    def wait_until(timeout = nil)
      timeout = Elementis.config.element_timeout if timeout.nil?
      ElementVerification.new(self, timeout)
    end

    def present?
      page.has_selector?(*@args)
    end

    def visible?
      element.visible?
    end

    def enabled?
      !element.disabled?
    end

    def click
      Log.info "Clicking on #{self}"
      element.click
    end

    def send_keys(*args)
      Log.info("Sending keys: #{args} to element: (#{self})")
      element.send_keys(*args)
    end

    def text=(*args)
      Log.info("Setting element text to: #{args} to element: (#{self})")
      element.set("")
      element.set(*args)
    end

    def to_s
      "#{@args}"
    end

    def method_missing(method_sym, *arguments, &block)
      if element.respond_to?(method_sym)
        element.method(method_sym).call(*arguments, &block)
      else
        super
      end
    end

    private

    def stale?
      return false unless @element.disabled?
    rescue StandardError
      Log.debug "Element '#{self}' is stale"
      return true
    end
  end
end
