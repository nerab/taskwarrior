module TaskWarrior
  module Commands
    #
    # Imports tasks from a JSON file into the TaskWarrior database
    #
    class Import < Command
      def initialize(file)
        super()
        @file = file
      end

      def run
        import(@file)
      end
    end
  end
end
