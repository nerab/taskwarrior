require 'active_model'

module TaskWarrior
  class Task
    attr_accessor :description, :id, :entry, :status, :uuid, 
                  :project, :dependencies, :parent, :children, 
                  :priority, :tags, :annotations, 
                  :start_at, :wait_at, :end_at, :due_at

    include ActiveModel::Validations

    validates :description, :id, :entry, :status, :uuid, :presence => true

    validates :id, :numericality => { :only_integer => true, :greater_than => 0}

    validates :uuid, :format => {:with => /[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}/,
                                 :message => "'%{value}' does not match the expected format of a UUID"}

    validates :status, :inclusion => {:in => [:pending, :waiting, :complete], :message => "%{value} is not a valid status"}

    validates :priority, :inclusion => {
      :in => [:high, :medium, :low],
      :allow_nil => true,
      :allow_blank => true,
      :message => "%{value} is not a valid priority"
    }

    include TaskWarrior::Validations
    validate :entry_cannot_be_in_the_future

    def initialize(description)
      @description = description
      @dependencies = []
      @children = []
      @tags = []
      @annotations = []
    end

    def to_s
      "Task '#{description}'".tap{|result| result << " <#{uuid}>" if uuid}
    end
  end
end
