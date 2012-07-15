#!/usr/bin/env rake

require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new do |test|
  test.libs << 'lib' << 'test' << 'test/helpers'
#  test.test_files = FileList['test/**/test_*.rb']
  test.pattern = 'test/**/test_*.rb'
end

task :default => :test
