module TaskWarrior
  #
  # A DataMapper that makes new annotations from a JSON representation
  #
  class ProjectMapper
    class << self
      def load(name)
        Project.new(name)
      end
    end
  end
end
