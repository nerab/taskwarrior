require 'active_model'
require 'multi_json'
require 'date'

require "taskwarrior/version"

require "taskwarrior/validations"
require "taskwarrior/attributes"

require "taskwarrior/task_repository"
require "taskwarrior/project_repository"

require "taskwarrior/commands"

require "taskwarrior/task"
require "taskwarrior/project"
require "taskwarrior/tag"
require "taskwarrior/annotation"

require "taskwarrior/mappers"

module TaskWarrior
  #
  # Static, global access to the project repository
  #
  def self.projects
    @projects ||= ProjectRepository.new
  end

  #
  # Static, global access to the task repository
  #
  def self.tasks
    @tasks ||= TaskRepository.new
  end

  #
  # Static, global access to the tag repository
  #
  def self.tags
    @tasks ||= TagRepository.new
  end
end
