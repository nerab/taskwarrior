module TaskWarrior
  #
  # A DataMapper that makes new annotations from a JSON representation
  #
  class AnnotationMapper
    class << self
      def load(json)
        Annotation.new(json['description']).tap{|t|
          t.entry = DateTime.parse(json['entry'])
        }
      end
    end
  end
end