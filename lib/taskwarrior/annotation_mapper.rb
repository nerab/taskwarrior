# frozen_string_literal: true

module TaskWarrior
  #
  # A DataMapper that makes new annotations from a JSON representation
  #
  class AnnotationMapper
    class << self
      def map(json)
        Annotation.new(json['description']).tap do |t|
          t.entry = DateTime.parse(json['entry'])
        end
      end
    end
  end
end
