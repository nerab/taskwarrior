# frozen_string_literal: true

module TaskWarrior
  class Tag
    attr_reader :name

    include ActiveModel::Validations
    validates :name, presence: true
    validate :name_may_not_contain_spaces

    def initialize(tag_or_name, tasks = [])
      if tag_or_name.respond_to?(:name)
        @name = tag_or_name.name
        @tasks = tag_or_name.tasks
      else
        @name = tag_or_name
        @tasks = []
      end

      tasks.each do |task|
        self << task
      end
    end

    def <<(task)
      @tasks << task unless @tasks.include?(task)
    end

    attr_reader :tasks

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
      errors.add(:name, 'may not contain spaces') if !name.blank? && name[/\s/]
    end
  end
end
