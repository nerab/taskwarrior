module TaskWarrior
  class Repository
    def initialize
      @tasks = {}
      @projects = Hash.new{|hash, key| hash[key] = Project.new(key)}
      @tags = Hash.new{|hash, key| hash[key] = Tag.new(key)}
    end

    def load(input)
      MultiJson.load(input).each{|json|
        task = TaskMapper.load(json)
        @tasks[task.uuid] = task
        @projects[task.project].tasks << task if task.project

        # Create a new Tag object in @tags that is the value for each tag name
        task.tags.each{|tag_name| @tags[tag_name] << task}
      }

      # Replace the uuid of each dependency with the real task
      @tasks.each_value{|task| task.dependencies.map!{|uuid| @tasks[uuid]}}

      # Replace the project property of each task with a proper Project object carrying a name and all of the project's tasks
      @tasks.each_value{|task| task.project = @projects[task.project] if task.project}

      # Add child tasks to their parent, but keep them in the global index
      @tasks.each_value do |task|
        if task.parent
          parent = @tasks[task.parent]

          if parent # we know the parent
            parent.children << task
            task.parent = parent
          end
        end
      end
    end

    def dump
      MultiJson.dump(
        @tasks.map do |uuid, task|
          TaskMapper.dump(task)
        end
      )
    end

    def save(task)
      if @tasks[task.uuid]
        cmd = Commands::Update.new(task)
      else
        cmd = Commands::Insert.new(task)
      end

      cmd.execute
      @tasks[task.uuid] = task
    end

    def delete(task)
      Commands::Delete.new(task).execute if @tasks[task.uuid]
      @tasks[task.uuid] = nil
    end

    def tasks
      # Do not expose child tasks directly
      @tasks.values.reject{|t| t.parent}
    end

    # direct lookup by uuid
    def [](uuid)
      @tasks[uuid]
    end

    def projects
      @projects.values
    end

    def project(name)
      @projects[name] if @projects.has_key?(name)
    end

    def tags
      @tags.values
    end

    def tag(name)
      @tags[name] if @tags.has_key?(name)
    end
  end
end
