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
        args = ['rc.verbose=nothing']
        args << "project:#{@name}" unless @name.blank?
        task('_projects', args)
      end
    end
  end
end
