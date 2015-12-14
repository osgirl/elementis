require 'byebug'

module Elementis
  class << self
    attr_accessor :config
  end

  def self.configure
    self.config ||= Configuration.new
    yield config

    Capybara.configure do |c|
      if Capybara.respond_to?(:default_max_wait_time)
        c.default_max_wait_time = config.element_timeout
      else
        c.default_wait_time = config.element_timeout
      end
    end
  end

  def self.reset!
    self.config = Configuration.new
  end

  def self.javascript_driver?
    Capybara.current_driver == Capybara.javascript_driver
  end

  class Configuration
    attr_accessor :page_load_timeout, :element_timeout, :log_level
    attr_accessor :highlight_verifications, :highlight_duration

    def initialize
      @page_load_timeout = 15
      @element_timeout = 5
      @log_level = :fatal
      @highlight_verifications = false
      @highlight_duration = 0.100
    end

    def print_configuration
      puts "\n***** ELementis Configuration *****"
      self.instance_variables.each { |x| puts "#{self.class.name}.#{x.to_s.gsub(/@/, '')} = #{instance_variable_get(x).inspect}"}
      puts
    end
  end


  require 'elementis/version'
  require 'elementis/logging'
  require 'elementis/capybara_extensions/script_args'
  require 'elementis/capybara_extensions/element/interactions'
  require 'elementis/core_extensions/array/extract_options'
  require 'elementis/element_extensions'
  require 'elementis/element_verification'
  require 'elementis/element'
  require 'elementis/elements'
  require 'elementis/page'

  Capybara::Node::Element.include Elementis::CapybaraExtensions::Element::Interactions
end