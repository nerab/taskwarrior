require 'test_helper'

class TestPriorityMapper < Test::Unit::TestCase
  def test_nil
    assert_nil(TaskWarrior::PriorityMapper.load(nil))
  end
  
  def test_empty
    assert_nil(TaskWarrior::PriorityMapper.load(''))
  end
  
  def test_low
    assert_equal(:low, TaskWarrior::PriorityMapper.load('L'))
  end
  
  def test_medium
    assert_equal(:medium, TaskWarrior::PriorityMapper.load('M'))
  end
  
  def test_high
    assert_equal(:high, TaskWarrior::PriorityMapper.load('H'))
  end
  
  def test_unknown
    assert_nil(TaskWarrior::PriorityMapper.load('crap'))
  end
end