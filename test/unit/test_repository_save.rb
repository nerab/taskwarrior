require 'test_helper'

class TestRepositorySave < MiniTest::Unit::TestCase
  include TaskWarrior

  def setup
    @repo = TaskRepository.new
  end

  def test_plain_task_single
    assert_equal(0, @repo.all.size)
#    assert_equal(0, @repo.projects.size)
#    assert_equal(0, @repo.tags.size)

    task = Task.new('foo equals bar')
    @repo.save(task)

    assert_equal(1, @repo.all.size)
#    assert_equal(0, @repo.projects.size)
#    assert_equal(0, @repo.tags.size)
  end
end
