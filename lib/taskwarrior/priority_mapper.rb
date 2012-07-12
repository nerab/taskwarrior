module TaskWarrior
  class PriorityMapper
    class << self
      def load(json)
        {'H' => :high, 'M' => :medium, 'L' => :low}[json]
      end
    end
  end
end