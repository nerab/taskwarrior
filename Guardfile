guard 'bundler' do
  watch('Gemfile')
  watch(/^.+\.gemspec/)
end

guard :minitest, :test_paths => ['test/unit', 'test/integration'] do
  watch('lib/taskwarrior.rb'){"test"}
  watch(%r{^lib/taskwarrior/(.+)\.rb$}){|m| "test/unit/test_#{m[1]}.rb"}
  watch(%r{^test/unit/test_(.+)\.rb$})
  watch('test/test_helper.rb'){"test"}
  watch('test/helpers/**/*'){"test"}
end
