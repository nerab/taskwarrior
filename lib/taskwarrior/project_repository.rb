module TaskWarrior
  class ProjectRepository
    #
    # Saves a single project in the database
    #
    def save(project)
      #TODO raise ValidationError unless project.valid?

      if find(project.name).any?
        cmd = Commands::UpdateProject.new(project)
      else
        cmd = Commands::CreateProject.new(project)
      end

      cmd.run
    end

    def delete(project)
      Commands::DeleteProject.new(project).run
    end

    def find(term)
      load(Commands::FindProject.new(term).run)
    end

    def all
      find('')
    end

    def size
      all.size
    end

    # direct lookup by name
    def [](name)
      find(name).first
    end

    private

    #
    # Loads multiple projects; one line is one project
    #
    def load(input)
      return [] if input.blank?

      projects = {}

      input.each_line do |name|
        projects[name] = ProjectMapper.load(name)
      end

      projects.values
    end
  end
end
