require 'rubygems'
require 'rake'
require './lib/contacts'

desc "Default Task"
task :default => [ :test ]

# Run the unit tests
desc "Run all unit tests"
require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end


# Make a console, useful when working on tests
desc "Generate a test console"
task :console do
   verbose( false ) { sh "irb -I lib/ -r 'contacts'" }
end

