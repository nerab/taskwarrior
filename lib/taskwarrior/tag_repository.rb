module TaskWarrior
  class TagRepository
    #
    # Saves a single tag in the database
    #
    def save(tag)
      #TODO raise ValidationError unless tag.valid?

      if find(tag.name).any?
        cmd = Commands::Updatetag.new(tag)
      else
        cmd = Commands::Createtag.new(tag)
      end

      cmd.run
    end

    def delete(tag)
      Commands::DeleteTag.new(tag).run
    end

    def find(name)
      load(Commands::FindTag.new(name).run)
    end

    def all
      find('')
    end

    def size
      all.size
    end

    # direct lookup by name
    def [](name)
      find(name).first
    end

    private

    #
    # Loads multiple tags; one line is one tag
    #
    def load(input)
      return [] if input.blank?
      input.lines.map{|name| TagMapper.load(name)}
=begin
      tags = {}

      input.each_line do |name|
        tags[name] = TagMapper.load(name)
      end

      tags.values
=end
    end
  end
end
