module TaskWarrior
  module Commands
    class Create < Command
      def initialize(task)
        super()
        @task = task
      end

      def run
        import(MultiJson.dump(TaskMapper.dump(@task)))
      end
    end
  end
end