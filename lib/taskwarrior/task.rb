module TaskWarrior
  class Task
    include TaskWarrior::Attributes

    attributes :description, :id, :entry, :status, :uuid, :project, :dependencies, :parent, :children,
               :priority, :tags, :annotations, :start_at, :wait_at, :end_at, :due_at

    include ActiveModel::Validations

    validates :description, :id, :entry, :status, :uuid, :presence => true

    validates :id, :numericality => {
      :only_integer => true,
      :greater_than => 0
    }

    validates :uuid, :format => {
      :with    => /[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}/,
      :message => "'%{value}' does not match the expected format of a UUID"
    }

    validates :status, :inclusion => {
      :in      => [:pending, :waiting, :complete],
      :message => "%{value} is not a valid status"
    }

    validates :priority, :inclusion => {
      :in          => [:high, :medium, :low],
      :allow_nil   => true,
      :allow_blank => true,
      :message     => "%{value} is not a valid priority"
    }

    include TaskWarrior::Validations
    validate :entry_cannot_be_in_the_future
    validates :start_at, :wait_at, :end_at, :due_at, :with => :must_be_date_or_nil

    def initialize(description)
      @description = description
      @dependencies = []
      @children = []
      @tags = []
      @annotations = []

      # http://www.ruby-forum.com/topic/164078#722181
      @uuid = %x[uuidgen].strip.downcase
    end

    def to_s
      "Task '#{description}'".tap{|result| result << " <#{uuid}>" if uuid}
    end

    # other may have the same uuid, but if its attributes differ, it will not be equal
    def eql?(other)
      self.class.attributes.each do |attr|
        return false unless send(attr).eql?(other.send(attr))
      end
    end

    def hash
      uuid.hash
    end

    # Tasks are entity objects. They have their identity defined by the uuid.
    # If the uuids are the same, the tasks are identical.
    def ==(other)
      return false unless other.is_a?(Task)
      uuid == other.uuid
    end
  end
end
