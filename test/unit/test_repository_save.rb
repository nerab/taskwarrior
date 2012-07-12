require 'test_helper'

class TestRepositorySave < Test::Unit::TestCase
  include TaskWarrior

  def setup
    @repo = Repository.new
  end

  def test_plain_task_single
    assert_equal(0, @repo.tasks.size)
    assert_equal(0, @repo.projects.size)
    assert_equal(0, @repo.tags.size)

    task = Task.new('foo equals bar')
    @repo.save(task)

    assert_equal(1, @repo.tasks.size)
    assert_equal(0, @repo.projects.size)
    assert_equal(0, @repo.tags.size)
  end
end
