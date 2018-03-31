# frozen_string_literal: true

module TaskWarrior
  #
  # A DataMapper that makes new Tasks from a JSON representation
  #
  class TaskMapper
    class << self
      def map(json)
        Task.new(json['description']).tap do |t|
          t.id = json['id'].to_i
          t.uuid = json['uuid']
          t.entry = DateTime.parse(json['entry'])
          t.status = json['status'].to_sym
          t.project = json['project']

          if json['depends']
            t.dependencies = if json['depends'].respond_to?(:split)
                               json['depends'].split(',')
                             else
                               json['depends']
                             end
          end

          t.parent = json['parent'] # Children will be cross-indexed in the repository
          t.priority = PriorityMapper.map(json['priority'])
          json['tags']&.each { |tag| t.tags << tag }
          json['annotations']&.each { |annotation| t.annotations << AnnotationMapper.map(annotation) }

          %w[start wait end due].each do |datish|
            t.send("#{datish}_at=", DateTime.parse(json[datish])) if json[datish]
          end
        end
      end
    end
  end
end
