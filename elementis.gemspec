# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elementis/version'

Gem::Specification.new do |s|
  s.name          = "elementis"
  s.version       = Elementis::VERSION
  s.authors       = ["AlconTech LLC"]

  s.summary       = "Page Object DSL utilizing Capybara"
  s.description   = "Elementis provides an simple, expressive DSL for verifying your site, utilizing the Page Object Model pattern around Capybara"
  s.homepage      = "http://github.com/rizzza/elementis"
  s.license       = "MIT"
  s.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|s|features)/}) }
  s.bindir        = "exe"
  s.executables   = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'capybara', ['>= 2.1', '< 3.0']
  s.add_dependency 'capybara_minitest_spec'

  s.add_development_dependency 'minitest', ['>= 5.8.2', '< 6.0']
  s.add_development_dependency 'shoulda'
  s.add_development_dependency 'minitest-reporters', '~>1.1'
  s.add_development_dependency 'selenium-webdriver', '2.48.1'
  s.add_development_dependency 'pry'
end
