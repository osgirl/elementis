# minitest 'minitest/unit'
require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/reporters'
require 'shoulda/context'

require 'selenium-webdriver'
require 'capybara'
require 'capybara/dsl'
require 'elementis'
require 'page'

Minitest::Reporters.use!

$LOAD_PATH << '../lib'

Elementis.configure {}
Capybara.default_driver = :selenium