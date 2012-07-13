module TaskWarrior
  module Commands
    #
    # Find one or more projects by name
    #
    class FindProject < Command
      def initialize(name)
        @name = name
      end

      def run
        task('_projects', ["project:#{@name}", 'rc.verbose=nothing'])
      end
    end
  end
end
