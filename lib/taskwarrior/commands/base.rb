require 'tempfile'

module TaskWarrior
  module Commands
    class Command
      def initialize
        raise "The TaskWarrior binary '#{TASK}' must be available and at least v2.0." unless task('_version') =~ /2\.\d\.\d/
      end

    protected
      def export(args = [])
        task('export', ['rc.json.array=on', 'rc.verbose=nothing'].concat(Array(args)))
      end

      def import(json)
        # cat <(echo {"one":"two"})
        # This should actually be working, but apparently Ruby's +system+ command cannot handle process substitution
        #   task('import', ["<(echo #{json})"])
        # So we will present a temporary file to task as a workaround ...
        file = Tempfile.new('taskwarrior-import')

        begin
          file.write(json)
          file.flush
          task('import', file.path)
        ensure
          file.close!
        end
      end

    private
      TASK = 'task'

      def task(cmd, args = [])
        %x[#{build_line(cmd, args)}].chomp
      end

      def build_line(cmd, args = [])
        [].tap{|line|
          # the task command itself
          line << TASK

          # any filters or config overrides
          line << Array(args).map{|a| a.to_s.strip}.join(' ')

          # the task command, e.g. export or done
          line << cmd.strip

          # clean up
          line.reject!{|part| part.empty?}
        }.join(' ')
      end
    end
  end
end
