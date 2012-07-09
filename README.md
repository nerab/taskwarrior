# taskwarrior

Ruby bindings for [TaskWarrior](http://taskwarrior.org). Right now this gem provides read-only access to tasks, projects, tags etc.

[![Build Status](https://secure.travis-ci.org/nerab/taskwarrior.png?branch=master)](http://travis-ci.org/nerab/taskwarrior)

## Installation

Add this line to your application's Gemfile:

    gem 'taskwarrior'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install taskwarrior

## Usage

`TaskWarrior::Repository` is the main entry point. It expects an array of JSON objects, typically produced by `task export`. Technically, anything that can be consumed by `JSON.parse` is fine as long as it follows the format TaskWarrior uses.

	# Assuming that a TaskWarrior export was written to a file
	r = TaskWarrior::Repository.new(File.read('/tmp/task_export.json'))

Once instantiated, the repository provides access to tasks, projects and tags. Each task will also carry its attributes (description, uuid, etc) as well as its project and tags.

	puts r.tasks.size
	puts r.projects.size
	puts r.tags.size

	puts r.tasks.first.description
	puts r.tasks.first.project.name
	puts r.tasks.first.tags.join(' ')

Please see the [examples](/nerab/taskwarrior/tree/master/examples) for further use, or have a look at the [twdeps](/nerab/twdeps) tool which creates a graph that visualizes the dependencies between tasks.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
