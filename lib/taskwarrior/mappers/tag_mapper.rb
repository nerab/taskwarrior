module TaskWarrior
  #
  # A DataMapper that makes new tags from a JSON representation
  #
  class TagMapper
    class << self
      def load(name, load_tasks = true)
        Tag.new(name).tap do |t|
          t.tasks.concat(TaskWarrior.tasks.find_by_tag(t, false)) if load_tasks
        end
      end
    end
  end
end
