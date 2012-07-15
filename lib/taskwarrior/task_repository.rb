module TaskWarrior
  class TaskRepository
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

    def size
      all.size
    end

    # Lookup a task by its uuid. Returns exactly one object - either the task identified by +uuid+ or nil.
    def [](uuid)
      load(Commands::ReadTask.new(uuid).run).first
    end

    #
    # Find all tasks belonging to +project_or_name+
    #
    def find_by_project(project_or_name, load_projects = true)
      if project_or_name.respond_to?(:name)
        term = project_or_name.name
      else
        term = project_or_name
      end

      load(Commands::FindTasksByProject.new(term).run, :load_projects => load_projects, :load_tags => false)
    end

    #
    # Find all tasks belonging to +tag_or_name+
    #
    def find_by_tag(tag_or_name, load_tags = true)
      if tag_or_name.respond_to?(:name)
        term = tag_or_name.name
      else
        term = tag_or_name
      end

      load(Commands::FindTasksByTag.new(term).run, :load_projects => false, :load_tags => load_tags)
    end

    private

    #
    # Loads multiple tasks from their JSON representation
    #
    def load(input, options = {})
      return [] if input.blank?

      options = {:load_projects => true, :load_tags => true}.merge(options)
      tasks = {}

      MultiJson.load(input).each{|json|
        task = TaskMapper.load(json)
        tasks[task.uuid] = task
      }

      # Replace the uuid of each dependency with the real task
      tasks.each_value{|task| task.dependencies.map!{|uuid| tasks[uuid]}}

      # Replace the project property of each task with a proper Project object carrying a name and all of the project's tasks
      if options[:load_projects]
        tasks.each_value.select{|task| task.project}.each do |task|
            projects = TaskWarrior.projects.find(task.project)
            raise "Ambiguous project name: #{projects.size} projects match #{task.project}" if projects.size > 1
            task.project = projects.first
        end
      end

      # Replace the project property of each task with a proper Project object carrying a name and all of the project's tasks
      if options[:load_tags]
        tasks.each_value do |task|
          # Replace those that are not a valid Tag yet
          task.tags.reject{|tag| tag.respond_to?(:name)}.each do |tag|
            task.tags << TaskWarrior.tags[task.tags.delete(tag)]
          end
        end
      end

      # Add child tasks to their parent, but keep them in the global index
      tasks.each_value do |task|
        if task.parent
          parent = self[task.parent]

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
