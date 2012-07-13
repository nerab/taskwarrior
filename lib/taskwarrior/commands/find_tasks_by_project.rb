module TaskWarrior
  module Commands
    #
    # Find tasks in the database
    #
    class FindTasksByProject < Command
      def initialize(project_name)
        super()
        @project_name = project_name
      end

      #
      # Returns an array of tasks matching the +project_name+ that was passed to the
      # constructor of this command
      #
      def run
        export("project:#{@project_name}")
      end
    end
  end
end
