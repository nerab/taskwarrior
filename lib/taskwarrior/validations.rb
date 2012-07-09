module TaskWarrior
  module Validations
    def entry_cannot_be_in_the_future
      begin
        if !entry.blank? and entry > DateTime.now
          errors.add(:entry, "can't be in the future")
        end
      rescue
        errors.add(:entry, "must be comparable to DateTime")
      end
    end
  end
end
