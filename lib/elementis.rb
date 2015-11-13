require "elementis/version"

module Elementis
  class << self
    attr_accessor :config
  end

  def self.configure
    self.config ||= Configuration.new
    yield config

    Capybara.configure do |c|
      c.match = config.capybara_match
      c.exact = config.capybara_exact
      c.ignore_hidden_elements = config.capybara_ignore_hidden_elements
      c.visible_text_only = config.capybara_visible_text_only
      if Capybara.respond_to?(:default_max_wait_time)
        c.default_max_wait_time = config.element_timeout
      else
        c.default_wait_time = config.element_timeout
      end
    end
  end

  def self.reset
    self.config ||= Configuration.new
  end

  class Configuration
    attr_accessor :element_timeout, :log_level
    attr_accessor :highlight_verifications, :highlight_duration
    attr_accessor :capybara_match, :capybara_exact, :capybara_ignore_hidden_elements, :capybara_visible_text_only


    def initialize
      @element_timeout = 5
      @log_level = :fatal
      @highlight_verifications = false
      @highlight_duration = 0.100
      @capybara_match = :smart
      @capybara_exact = false
      @capybara_ignore_hidden_elements = true
      @capybara_visible_text_only = true
    end

    def print_configuration
      puts "\n***** ELementis Configuration *****"
      Elementis::Configuration.instance_variables.each { |x| puts "#{self.name}.#{x.to_s.gsub(/@/, '')} = #{instance_variable_get(x).inspect}"}
      puts
    end
  end
end
