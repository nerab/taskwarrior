require 'shellwords'

module TaskWarrior
  module Commands
    class Command
      def initialize
#        # define each command understood by TaskWarrior as instance method of this class
#        commands.each do |cmd|
#          (class << self; self; end).class_eval do
#            define_method(cmd) do |*args|
#              task(cmd, args)
#            end
#          end
#        end

        raise "The TaskWarrior binary '#{TASK}' must be available and at least v2.0." unless task('_version') =~ /2\.\d\.\d/
      end

    protected
      def export(args = [])
        task('export', ['rc.json.array=on', 'rc.verbose=nothing'].concat(args))
      end

    private
      TASK = 'task'

#      # bootstrap
#      def commands
#        task('_commands').split
#      end

      def task(cmd, args = [])
        %x[#{build_line(cmd, args)}].chomp
      end

      #
      # +args* may be an array or map
      #
      def build_line(cmd, args = [])
        [].tap{|line|
          # the task command itself
          line << TASK

          # any filters or config overrides
          line << args.collect{|a| a.to_s.strip}

          # the task command, e.g. export or done
          line << cmd.strip

          # clean up
          line.reject!{|part| part.empty?}
STDERR.puts "complete line is #{line.join(' ')}"
        }.join(' ')
      end
    end
  end
end
