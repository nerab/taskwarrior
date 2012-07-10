require 'test_helper'

class TestProject < Test::Unit::TestCase
  include TaskWarrior::Test::Validations

  def test_name
    project = TaskWarrior::Project.new('foo')
    assert_valid(project)
    assert_empty(project.tasks)
  end

  def test_empty_tasks
    project = TaskWarrior::Project.new('foo', [])
    assert_valid(project)
    assert_empty(project.tasks)
  end

  def test_with_tasks
    project = TaskWarrior::Project.new('foo', [TaskWarrior::Task.new('foobar')])
    assert_valid(project)
    assert_equal(1, project.tasks.size)
  end

  def test_name_nil
    project = TaskWarrior::Project.new(nil)
    assert_invalid(project)
  end

  def test_name_empty
    project = TaskWarrior::Project.new('')
    assert_invalid(project)
  end

  def test_name_with_space
    project = TaskWarrior::Project.new('foo bar')
    assert_invalid(project)
  end

  def test_name_just_space
    project = TaskWarrior::Project.new(' ')
    assert_invalid(project)
  end

  def test_add_task
    project = TaskWarrior::Project.new('foo')
    assert_empty(project.tasks)
    t1 = TaskWarrior::Task.new('foobar')
    t2 = TaskWarrior::Task.new('foobaz')
    project << t1
    project << t2
    assert_equal(2, project.tasks.size)
    assert_equal(project, t1.project)
    assert_equal(project, t2.project)
  end

  def test_equality
    a1 = TaskWarrior::Project.new('foo')
    a2 = TaskWarrior::Project.new('foo')

    assert_equal(a1, a2)
  end

  def test_equality_different_name
    a1 = TaskWarrior::Project.new('foo')
    a2 = TaskWarrior::Project.new('bar')
    assert_inequality(a1, a2)
  end

  def test_equality_different_tasks
    a1 = TaskWarrior::Project.new('foo')
    a2 = TaskWarrior::Project.new('foo', [TaskWarrior::Task.new('foobar')])

    assert_inequality(a1, a2)
  end

  def test_equality_different_name_and_tasks
    a1 = TaskWarrior::Project.new('foo')
    a2 = TaskWarrior::Project.new('bar', [TaskWarrior::Task.new('baz')])

    assert_inequality(a1, a2)
  end
end
