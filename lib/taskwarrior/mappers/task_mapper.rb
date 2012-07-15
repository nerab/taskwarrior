module TaskWarrior
  #
  # A DataMapper that makes new Tasks from a JSON representation
  #
  class TaskMapper
    class << self
      def load(json)
        Task.new(json['description']).tap{|t|
          t.id = json['id'].to_i
          t.uuid = json['uuid']
          t.entry = DateTime.parse(json['entry'])
          t.status = json['status'].to_sym
          t.project = json['project']

          if json['depends']
            if json['depends'].respond_to?(:split)
              t.dependencies = json['depends'].split(',')
            else
              t.dependencies = json['depends']
            end
          end

          t.parent = json['parent'] # Children will be cross-indexed in the repository
          t.priority = PriorityMapper.load(json['priority'])
          json['tags'].each{|tag| t.tags << tag} if json['tags']
          json['annotations'].each{|annotation| t.annotations << AnnotationMapper.load(annotation)} if json['annotations']

          %w{start wait end due}.each do |datish|
            t.send("#{datish}_at=", DateTime.parse(json[datish])) if json[datish]
          end
        }
      end

      def dump(task)
        {}.tap do |h|
          h['description'] = task.description
          h['id']          = task.id
          h['uuid']        = task.uuid
          h['entry']       = task.entry.to_s
          h['status']      = task.status
          h['project']     = task.project.name if task.project
          h['depends']     = task.dependencies.map{|d| d.uuid} if task.dependencies.any?
          h['parent']      = task.parent.uuid if task.parent

          # TODO h['priority']
          # TODO h['tags']
          # TODO h['annotations']

          h['start_at']    = task.start_at.to_s if task.start_at
          h['wait_at']     = task.wait_at.to_s if task.wait_at
          h['end_at']      = task.end_at.to_s if task.end_at
          h['due_at']      = task.due_at.to_s if task.due_at
        end
      end
    end
  end
end
