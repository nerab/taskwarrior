module TaskWarrior
  module Commands
    class UpdateTask < Command
      def initialize(task)
      end

      def run
        #
        # Until we will get JSON update of an existing task, we will
        # need to diff and spit out modify commands. Deleting and re-creating
        # does not seem to work as TaskWarrior only marks tasks as deleted, but
        # keeps them including the uuid.
        #
        # We also need to save changed tags and project of the task.
        #
        raise "Not yet implemented"
      end
    end
  end
end
