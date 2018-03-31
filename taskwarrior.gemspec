
# frozen_string_literal: true

require File.expand_path('lib/taskwarrior/version', __dir__)

Gem::Specification.new do |gem|
  gem.authors       = ['Nicholas E. Rabenau']
  gem.email         = ['nerab@gmx.net']
  gem.summary       = 'Ruby wrapper for TaskWarrior'
  gem.description   = 'Wraps access to TaskWarrior, the command-line task manager, in a Ruby gem.'

  gem.files         = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'taskwarrior'
  gem.require_paths = ['lib']
  gem.version       = TaskWarrior::VERSION

  gem.add_dependency 'activemodel'

  gem.add_development_dependency 'activesupport'
  gem.add_development_dependency 'guard-bundler'
  gem.add_development_dependency 'guard-test'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rubocop'
  gem.add_development_dependency 'twtest'
end
