module TaskWarrior
  module Validations
    def must_be_date_or_nil(sym)
      datish = self.send(sym)
      if !(datish.nil? or datish.is_a?(DateTime))
        errors.add(sym, "must be nil or a valid DateTime object")
      end
    end

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
