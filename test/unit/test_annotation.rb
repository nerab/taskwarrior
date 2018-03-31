# frozen_string_literal: true

require 'test_helper'
require 'date'
require 'active_support/core_ext'

class TestAnnotation < MiniTest::Test
  include TaskWarrior::Test::Validations

  def setup
    @annotation = TaskWarrior::Annotation.new

    @annotation.description = 'foo bar'
    @annotation.entry = DateTime.now
  end

  def test_description
    assert_equal('foo bar', @annotation.description)
    assert_valid(@annotation)
  end

  def test_description_nil
    @annotation.description = nil
    assert_invalid(@annotation)
  end

  def test_description_empty
    @annotation.description = ''
    assert_invalid(@annotation)
  end

  def test_entry_nil
    @annotation.entry = nil
    assert_invalid(@annotation)
  end

  def test_entry_empty
    @annotation.entry = ''
    assert_invalid(@annotation)
  end

  def test_entry_wrong_format
    @annotation.entry = 'foobar'
    assert_invalid(@annotation)
  end

  def test_entry_future
    @annotation.entry = DateTime.now.advance(days: 1)
    assert_invalid(@annotation)
  end

  def test_valid
    assert_valid(@annotation)
  end

  def test_equality
    a1 = TaskWarrior::Annotation.new('foo')
    a2 = TaskWarrior::Annotation.new('foo')

    assert_equal(a1, a2)
  end

  def test_equality_different_description
    a1 = TaskWarrior::Annotation.new('foo')
    a2 = TaskWarrior::Annotation.new('bar')
    assert_inequality(a1, a2)
  end

  def test_equality_different_entry
    a1 = TaskWarrior::Annotation.new('foo')
    a1.entry = DateTime.now

    a2 = TaskWarrior::Annotation.new('foo')
    a2.entry = DateTime.now.advance(days: -1)

    assert_inequality(a1, a2)
  end

  def test_equality_different_description_and_entry
    a1 = TaskWarrior::Annotation.new('foo')
    a1.entry = DateTime.now

    a2 = TaskWarrior::Annotation.new('bar')
    a2.entry = DateTime.now.advance(days: -1)

    assert_inequality(a1, a2)
  end
end
