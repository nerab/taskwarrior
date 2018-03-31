# -*- encoding: utf-8 -*-
require File.expand_path('../lib/taskwarrior/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Nicholas E. Rabenau"]
  gem.email         = ["nerab@gmx.net"]
  gem.summary       = %q{Ruby wrapper for TaskWarrior}
  gem.description   = %q{Wraps access to TaskWarrior, the command-line task manager, in a Ruby gem.}

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "taskwarrior"
  gem.require_paths = ["lib"]
  gem.version       = TaskWarrior::VERSION

  gem.add_dependency 'activemodel'

  gem.add_development_dependency 'activesupport'
  gem.add_development_dependency 'twtest'
  gem.add_development_dependency 'guard-test'
  gem.add_development_dependency 'guard-bundler'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'pry'
end
