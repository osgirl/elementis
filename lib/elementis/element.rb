module Elementis
  class Element
    include Elementis::ElementExtensions

    attr_writer :element

    def initialize(*args)
      @element = nil
      @name = args.delete_at(0)
      @args = args
    end

    def element(opts = {})
      if stale? || !opts.empty?
        unless opts.empty?
          requested_opts = @args.extract_options!
          requested_opts.merge!(opts)
          @args += [requested_opts]
        end

        Log.info "Finding element #{self}"
        @element = Capybara.current_session.find(*@args)
      end

      self.highlight
      @element
    end

    # Find an element within this element
    def find_in_children(*args)
      child = nil
      Capybara.current_session.within(element) do
        child = self.class.new(:child, *args)
        child.element
      end

      child
    end

    def find_in_siblings(*_args)
      fail NotImplementedError
    end

    def parent
      fail NotImplementedError
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
      Capybara.current_session.has_selector?(*@args)
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

    def set(value)
      Log.info "Setting #{self} to #{value}"
      element.set(value)
    end

    def send_keys(*args)
      Log.info("Sending keys: #{args} to element: (#{self})")
      element.send_keys(*args)
    end

    def text=(*args)
      Log.info("Setting element (#{self}) text to: #{args} ")
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
      return true if @element.nil?
      @element.disabled?
    rescue StandardError
      Log.info("Element #{self} is stale")
      return true
    end

    def force_stale
      @element = nil
    end
  end
end
