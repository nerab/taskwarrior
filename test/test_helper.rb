# frozen_string_literal: true

require 'twtest'
require 'minitest/autorun'
require 'taskwarrior'

module TaskWarrior
  module Test
    module Fixtures
      def fixture(name)
        File.join(File.dirname(__FILE__), 'fixtures', name)
      end
    end

    module Validations
      def assert_valid(task)
        assert(task.valid?, error_message(task.errors))
      end

      def assert_invalid(task)
        assert(task.invalid?, 'Expect validation to fail')
      end

      def assert_equality(a1, a2)
        refute_equal(a1.object_id, a2.object_id)
        assert_equal(a1, a2)
        assert(a1 == a2)
        assert(a1.hash == a2.hash)
        assert(a1.eql?(a2))
        assert_equal(1, [a1, a2].uniq.size)
      end

      def assert_inequality(a1, a2)
        refute_equal(a1.object_id, a2.object_id)
        refute_equal(a1, a2)
        assert(a1 != a2)
        assert(a1.hash != a2.hash)
        assert(!a1.eql?(a2))
        assert_equal(2, [a1, a2].uniq.size)
      end

      def error_message(errors)
        errors.each_with_object([]) do |e, result|
          result << e.join(' ')
        end.join("\n")
      end
    end
  end
end
