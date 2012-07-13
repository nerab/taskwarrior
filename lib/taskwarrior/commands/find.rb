module TaskWarrior
  module Commands
    #
    # Find tasks in the database
    #
    class Find < Command
      def initialize(term)
        super()
        @term = term
      end

      #
      # Returns an array of tasks matching the +term+ that was passed to the
      # constructor of this command
      #
      def run
        export(@term)
      end
    end
  end
end
