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
      load(Commands::FindProject.new(term).run).reject{|t| t.parent} # Do not expose child projects directly
    end

    def all
      find('')
    end

    # direct lookup by uuid
    def [](uuid)
      load(Commands::ReadProject.new(uuid).run).first
    end

    private

    #
    # Loads multiple projects from their JSON representation
    #
    def load(input)
      return [] if input.blank?

      projects = {}

      MultiJson.load(input).each{|json|
        project = projectMapper.load(json)
        projects[project.uuid] = project

        # TODO Move this to ProjectRepository
        #@projects[project.project].projects << project if project.project

        # Create a new Tag object in @tags that is the value for each tag name
        # TODO Move this to TagRepository
        #project.tags.each{|tag_name| @tags[tag_name] << project}
      }

      # Replace the uuid of each dependency with the real project
      projects.each_value{|project| project.dependencies.map!{|uuid| projects[uuid]}}

      # Replace the project property of each project with a proper Project object carrying a name and all of the project's projects
      # TODO Move this to ProjectRepository
      #@projects.each_value{|project| project.project = @projects[project.project] if project.project}

      # Add child projects to their parent, but keep them in the global index
      projects.each_value do |project|
        if project.parent
          parent = self[project.parent] #projects[project.parent]

          if parent # we know the parent
            parent.children << project
            project.parent = parent
          end
        end
      end

      projects.values
    end

=begin
    # TODO Move this to ProjectRepository#all
    def projects
      @projects.values
    end

    # TODO Move this to ProjectRepository#[](name)
    def project(name)
      @projects[name] if @projects.has_key?(name)
    end

    # TODO Move this to TagRepository#all
    def tags
      @tags.values
    end

    # TODO Move this to TagRepository#[](name)
    def tag(name)
      @tags[name] if @tags.has_key?(name)
    end

    # TODO Not needed anymore
    # Dumps all projects in this repository as JSON
    #
    def dump
      MultiJson.dump(
        @projects.map do |uuid, project|
          projectMapper.dump(project)
        end
      )
    end
=end
  end
end
