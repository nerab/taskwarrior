require 'active_model'
require 'date'

module TaskWarrior
  class Annotation
    attr_accessor :entry, :description

    include ActiveModel::Validations
    validates :entry, :presence => true
    validates :description, :presence => true

    include TaskWarrior::Validations
    validate :entry_cannot_be_in_the_future

    def initialize(description = nil, entry = nil)
      @description = description
      @entry = entry
    end

    def to_s
      "Annotation (#{entry}): #{description}"
    end

    def eql?(other)
      self == other
    end

    def hash
      entry.hash + description.hash
    end

    # Annotations are value objects. They have no identity. 
    # If entry date and description are the same, the annotations are identical.
    def ==(other)
      return false unless other.is_a?(Annotation)
      entry.eql?(other.entry) && description.eql?(other.description)
    end
  end
end
