#!/usr/bin/env ruby
require 'taskwarrior'

r = TaskWarrior::Repository.new(ARGF.read)

selected = r.tasks.select do |t|
  t.status == :completed && t.due_at > t.end_at if t.due_at && t.end_at
end

puts "#{selected.size} tasks completed before they were due:"

selected.each{|t|
  STDERR.puts "#{t.description}: #{(t.due_at - t.end_at).truncate} days early (due #{t.due_at}, completed #{t.end_at})"
}
