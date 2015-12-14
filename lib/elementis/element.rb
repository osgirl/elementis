module Elementis
  class Element
    include Capybara::DSL
    include Elementis::ElementExtensions

    def initialize(*args)
      @element = nil
      @by = args[0]
      @locator = args[1]
      @args = args
    end

    def element(opts = {})
      if @element.nil? || is_stale?
        unless opts.empty?
          requested_opts = @args.extract_options!
          requested_opts.merge!(opts)
          @args = @args + [requested_opts]
        end

        Log.info "Finding element #{self}"
        @element = find(*@args)
      end

      self.highlight
      @element
    end

    # Find an element within this element
    def find_in_children(*args)
      within(element) do
        find(*args)
      end
    end

    # TODO:
    def verify(timeout = nil)
      timeout = Elementis.config.element_timeout if timeout.nil?
      ElementVerification.new(self, timeout)
    end

    def wait_until(timeout = nil)
      timeout = Elementis.config.element_timeout if timeout.nil?
      ElementVerification.new(self, timeout)
    end

    def present?
      page.has_selector?(@by, @locator)
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
      element.send_keys *args
    end

    def text=(*args)
      Log.info("Setting element text to: #{args} to element: (#{self})")
      element.set ''
      element.set *args
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

    def is_stale?
      begin
        if !@element.disabled?
          return false
        end
      rescue Exception
        Log.debug "Element '#{self}' is stale"
        return true
      end
    end
  end
end