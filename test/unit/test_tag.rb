require 'test_helper'

class TestTag < Test::Unit::TestCase
  include TaskWarrior
  include TaskWarrior::Test::Validations

  def test_name
    tag = Tag.new('foo')
    assert_valid(tag)
    assert_empty(tag.tasks)
  end

  def test_empty_tasks
    tag = Tag.new('foo', [])
    assert_valid(tag)
    assert_empty(tag.tasks)
  end

  def test_with_tasks
    tag = Tag.new('foo', [Task.new('foobar')])
    assert_valid(tag)
    assert_equal(1, tag.tasks.size)
  end

  def test_name_nil
    tag = Tag.new(nil)
    assert_invalid(tag)
  end

  def test_name_empty
    tag = Tag.new('')
    assert_invalid(tag)
  end

  def test_name_with_space
    tag = Tag.new('foo bar')
    assert_invalid(tag)
  end

  def test_name_just_space
    tag = Tag.new(' ')
    assert_invalid(tag)
  end

  def test_construction
    foo = Tag.new('foo')
    assert_equal(foo, Tag.new(foo))
    assert_equal(Tag.new(foo), foo)
  end

  def test_equality
    a1 = Tag.new('foo')
    a2 = Tag.new('foo')

    assert_equal(a1, a2)
  end

  def test_equality_different_name
    a1 = Tag.new('foo')
    a2 = Tag.new('bar')
    assert_inequality(a1, a2)
  end

  def test_equality_different_tasks
    a1 = Tag.new('foo')
    a2 = Tag.new('foo')
    a2 << TaskWarrior::Task.new('baz')

    assert_inequality(a1, a2)
  end

  def test_equality_different_name_and_tasks
    a1 = Tag.new('foo')
    a2 = Tag.new('bar')
    a2 << TaskWarrior::Task.new('baz')

    assert_inequality(a1, a2)
  end
end
