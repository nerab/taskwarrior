module TaskWarrior
  module Commands
    #
    # Find one or more tags by name
    #
    class FindTag < Command
      def initialize(tag_name)
        @name = tag_name
      end

      def run
        args = ['rc.verbose=nothing']
        args << "+#{@name}" unless @name.blank?
        task('_tags', args)
      end
    end
  end
end
