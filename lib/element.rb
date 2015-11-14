require 'element_extensions'
require 'capybara'
require 'capybara/dsl'
require 'pry'

class Element
  include Capybara::DSL
  include ElementExtensions

  def initialize(*args)
    @element = nil
    @args = args
    @type, @locator = args
  end

  def element
    if @element.nil? || is_stale?
      puts "Finding element #{self}"
      @element = Capybara::find(@type, @locator)
    end

    @element
  end

  def to_s
    "#{@args}"
  end

  def verify(timeout = nil)
    timeout = Elementis.element_timeout if timeout.nil?
    ElementVerification.new(self, timeout)
  end

  def present?
    has_selector?(@args)
  end

  def visible?
    return element.visible?
  rescue Capybara::ElementNotFound
    return false
  end

  def enabled?
    return !element.disabled?
  rescue Capybara::ElementNotFound
    return false
  end

  def click
    puts "Clicking on #{self}"
    self.highlight
    element.click
  end

  def send_keys(*args)
    puts("Typing: #{args} into element: (#{self})")
    self.highlight
    element.send_keys *args
  end

  def text=(*args)
    element.set ''
    element.set *args
  end

  #
  # Search for an element within this element
  #
  # @param [Symbol] by  (:css or :xpath)
  # @param [String] locator
  #
  # @return [Element] element
  #
  # def find_element(*args)
  #   puts('Finding element...')
  #   element.find_element(by, locator)
  # end

  #
  # Search for an elements within this element
  #
  # @param [Symbol] by  (:css or :xpath)
  # @param [String] locator
  #
  # @return [Array] elements
  #
  # def find_elements(by, locator)
  #   element.find_elements(by, locator)
  # end

  # def save_element_screenshot
  #   puts ("Capturing screenshot of element...")
  #   self.scroll_into_view
  #
  #   timestamp = Time.now.strftime("%Y_%m_%d__%H_%M_%S")
  #   name = self.name.gsub(' ', '_')
  #   screenshot_path = File.join($current_run_dir, "#{name}__#{timestamp}.png")
  #   @driver.save_screenshot(screenshot_path)
  #
  #   location_x = self.location.x
  #   location_y = self.location.y
  #   element_width = self.size.width
  #   element_height = self.size.height
  #
  #   # ChunkyPNG commands tap into oily_png (performance-enhanced version of chunky_png)
  #   image = ChunkyPNG::Image.from_file(screenshot_path.to_s)
  #   image1 = image.crop(location_x, location_y, element_width, element_height)
  #   image2 = image1.to_image
  #   element_screenshot_path = File.join($current_run_dir, "#{name}__#{timestamp}.png")
  #   image2.save(element_screenshot_path)
  #   $screenshots_captured.push("#{name}__#{timestamp}.png")
  # end

  def method_missing(method_sym, *arguments, &block)
    puts "called #{method_sym} on element with args: #{@args}"
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
    rescue Exception => e
      puts "Stale element detected.... #{self}"
      return true
    end
  end
end