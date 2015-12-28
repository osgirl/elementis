require "simplecov"
SimpleCov.start

require "minitest/autorun"
require "minitest/pride"
require "minitest/focus"
require "shoulda/context"

require "selenium-webdriver"
require "capybara"
require "capybara/dsl"

require "elementis"
require "byebug"

Capybara.current_driver = :selenium
Capybara.run_server = false
Capybara.configure do |c|
  c.match = :smart
  c.exact = false
  c.ignore_hidden_elements = true
  c.visible_text_only = true
end

$LOAD_PATH << "../lib"

Elementis.configure {}
Elementis.config.print_configuration
