# frozen_string_literal: true

module TaskWarrior
  module Validations
    def must_be_date_or_nil(sym)
      datish = send(sym)
      unless datish.nil? || datish.is_a?(DateTime)
        errors.add(sym, 'must be nil or a valid DateTime object')
      end
    end

    def entry_cannot_be_in_the_future
      if !entry.blank? && (entry > DateTime.now)
        errors.add(:entry, "can't be in the future")
      end
    rescue StandardError
      errors.add(:entry, 'must be comparable to DateTime')
    end
  end
end
