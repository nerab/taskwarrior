module TaskWarrior
  module Commands
    class Delete < Command
      def initialize(task)
        @task = task
      end

      def run
        task("#{@task.uuid} delete", "rc.confirmation=no")
      end
    end
  end
end
