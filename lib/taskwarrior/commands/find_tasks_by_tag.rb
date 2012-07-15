module TaskWarrior
  module Commands
    #
    # Find tasks in the database
    #
    class FindTasksByTag < Command
      def initialize(tag_name)
        super()
        @tag_name = tag_name
      end

      #
      # Returns an array of tasks matching the +tag_name+ that was passed to the
      # constructor of this command
      #
      def run
        export("+#{@tag_name}")
      end
    end
  end
end
