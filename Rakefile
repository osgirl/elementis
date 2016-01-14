require "bundler/gem_tasks"
require "rake/testtask"
require "rubocop/rake_task"

# TODO: yard
# require 'yard'

RuboCop::RakeTask.new

# namespace :docs do
#   YARD::Rake::YardocTask.new :generate do |t|
#     t.files = ['lib/**/*.rb', '-', 'README.md']
#   end
# end

Rake::TestTask.new do |task|
  task.libs << %w{test lib}
  task.pattern = "test/*_test.rb"
end

task default: [:test, :rubocop]
