require 'active_model'

module TaskWarrior
  class Annotation
    attr_accessor :entry, :description

    include ActiveModel::Validations
    validates :entry, :presence => true
    validates :description, :presence => true

    include TaskWarrior::Validations
    validate :entry_cannot_be_in_the_future

    def initialize(description = nil)
      @description = description
    end

    def to_s
      "Annotation (#{entry}): #{description}"
    end
  end
end
