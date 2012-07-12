module TaskWarrior
  module Commands
    #
    # Read a single task, identified by +uuid+, from the database
    #
    class Read < Command
      def initialize(uuid)
      end

      def run
        raise "Not yet implemented"
        # task #{@uuid} export
      end
    end
  end
end
