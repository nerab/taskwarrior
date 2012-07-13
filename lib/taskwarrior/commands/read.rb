module TaskWarrior
  module Commands
    #
    # Read a single task, identified by +uuid+, from the database
    #
    class Read < Command
      def initialize(uuid)
        @uuid = uuid
      end

      def run
        export(@uuid)
      end
    end
  end
end
