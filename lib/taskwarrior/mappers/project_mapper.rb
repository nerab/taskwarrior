module TaskWarrior
  #
  # A DataMapper that makes new annotations from a JSON representation
  #
  class ProjectMapper
    class << self
      def load(name, load_tasks = true)
        Project.new(name).tap do |p|
          p.tasks.concat(TaskWarrior.tasks.find_by_project(p, false)) if load_tasks
        end
      end
    end
  end
end
