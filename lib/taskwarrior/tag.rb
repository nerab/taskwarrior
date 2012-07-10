require 'active_model'

module TaskWarrior
  class Tag
    attr_reader :name

    include ActiveModel::Validations
    validates :name, :presence => true
    validate :name_may_not_contain_spaces

    def initialize(tag_or_name, tasks = [])
      if tag_or_name.respond_to?(:name)
        @name = tag_or_name.name
        @tasks = tag_or_name.tasks
      else
        @name = tag_or_name
        @tasks = []
      end

      tasks.each{|task|
        self << task
      }
    end

    def <<(task)
      @tasks << task unless @tasks.include?(task)
    end

    def tasks
      @tasks
    end

    def to_s
      "Tag: #{name} (#{@tasks.size} tasks)"
    end

    def hash
      name.hash + tasks.hash
    end

    # Tags are value objects. They have no identity.
    # If name and tasks are the same, the tags are identical.
    def ==(other)
      return false unless other.is_a?(Tag)
      name.eql?(other.name) && tasks.eql?(other.tasks)
    end

    private
    def name_may_not_contain_spaces
      if !name.blank? and name[/\s/]
        errors.add(:name, "may not contain spaces")
      end
    end
  end
end
