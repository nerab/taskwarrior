module TaskWarrior
  class TaskRepository
=begin
    def initialize
      # TODO Move this to TagRepository
      @tags = Hash.new{|hash, key| hash[key] = Tag.new(key)}
    end
=end
    #
    # Saves a single task in the database
    #
    def save(task)
      #TODO raise ValidationError unless task.valid?

      if find(task.uuid).any?
        cmd = Commands::UpdateTask.new(task)
      else
        cmd = Commands::CreateTask.new(task)
      end

      cmd.run
    end

    def delete(task)
      Commands::DeleteTask.new(task).run
    end

    def find(term)
      load(Commands::FindTask.new(term).run).reject{|t| t.parent} # Do not expose child tasks directly
    end

    def all
      find('')
    end

    # direct lookup by uuid
    def [](uuid)
      load(Commands::ReadTask.new(uuid).run).first
    end

    private

    #
    # Loads multiple tasks from their JSON representation
    #
    def load(input)
      return [] if input.blank?

      tasks = {}

      MultiJson.load(input).each{|json|
        task = TaskMapper.load(json)
        tasks[task.uuid] = task

        # TODO Move this to ProjectRepository
        #@projects[task.project].tasks << task if task.project

        # Create a new Tag object in @tags that is the value for each tag name
        # TODO Move this to TagRepository
        #task.tags.each{|tag_name| @tags[tag_name] << task}
      }

      # Replace the uuid of each dependency with the real task
      tasks.each_value{|task| task.dependencies.map!{|uuid| tasks[uuid]}}

      # Replace the project property of each task with a proper Project object carrying a name and all of the project's tasks
      # TODO Move this to ProjectRepository
      #@tasks.each_value{|task| task.project = @projects[task.project] if task.project}

      # Add child tasks to their parent, but keep them in the global index
      tasks.each_value do |task|
        if task.parent
          parent = self[task.parent] #tasks[task.parent]

          if parent # we know the parent
            parent.children << task
            task.parent = parent
          end
        end
      end

      tasks.values
    end

=begin
    # TODO Move this to TagRepository#all
    def tags
      @tags.values
    end

    # TODO Move this to TagRepository#[](name)
    def tag(name)
      @tags[name] if @tags.has_key?(name)
    end

    # TODO Not needed anymore
    # Dumps all tasks in this repository as JSON
    #
    def dump
      MultiJson.dump(
        @tasks.map do |uuid, task|
          TaskMapper.dump(task)
        end
      )
    end
=end
  end
end
