require 'test_helper'
require 'date'
require 'active_support/core_ext'

# TODO Add tests for dependencies

class TestTask < Test::Unit::TestCase
  include TaskWarrior
  include TaskWarrior::Test::Validations
  
  def setup
    @task = Task.new('foobar')
    @task.id = 1
    @task.uuid = '66465716-b08d-41ea-8567-91b988a2bcbf'
    @task.entry = DateTime.now
    @task.status = :pending
  end

  def test_id_nil
    @task.id = nil
    assert_invalid(@task)
  end

  def test_id_0
    @task.id = 0
    assert_invalid(@task)
  end

  def test_uuid_nil
    @task.uuid = nil
    assert_invalid(@task)
  end

  def test_uuid_empty
    @task.uuid = ''
    assert_invalid(@task)
  end

  def test_uuid_wrong_format
    @task.uuid = 'abcdefg'
    assert_invalid(@task)
  end

  def test_description
    assert_equal('foobar', @task.description)
    assert_valid(@task)
  end

  def test_description_nil
    @task.description = nil
    assert_invalid(@task)
  end

  def test_description_empty
    @task.description = ''
    assert_invalid(@task)
  end

  def test_entry_nil
    @task.entry = nil
    assert_invalid(@task)
  end

  def test_entry_empty
    @task.entry = ''
    assert_invalid(@task)
  end

  def test_entry_wrong_format
    @task.entry = "foobar"
    assert_invalid(@task)
  end

  def test_entry_future
    @task.entry = DateTime.now.advance(:days => 1)
    assert_invalid(@task)
  end

  def test_status_nil
    @task.status = nil
    assert_invalid(@task)
  end

  def test_status_empty
    @task.status = ''
    assert_invalid(@task)
  end

  def test_status_unknown_string
    @task.status = "foobar"
    assert_invalid(@task)
  end

  def test_status_unknown_symbol
    @task.status = :foobar
    assert_invalid(@task)
  end

  def test_priority_nil
    @task.priority = nil
    assert_valid(@task)
  end

  def test_priority_empty
    @task.priority = ''
    assert_valid(@task)
  end

  def test_priority_unknown_string
    @task.priority = "foobar"
    assert_invalid(@task)
  end

  def test_priority_unknown_symbol
    @task.priority = :foobar
    assert_invalid(@task)
  end

  def test_priority_high
    @task.priority = :high
    assert_valid(@task)
  end

  def test_priority_medium
    @task.priority = :medium
    assert_valid(@task)
  end

  def test_priority_low
    @task.priority = :low
    assert_valid(@task)
  end

  def test_valid
    assert_valid(@task)
  end

  def test_start_at
    assert_datish(:start_at)
  end

  def test_wait_at
    assert_datish(:wait_at)
  end

  def test_end_at
    assert_datish(:end_at)
  end

  def test_due_at
    assert_datish(:due_at)
  end

  def assert_datish(sym)
    assert_datish_nil(sym)
    assert_datish_empty(sym)
    assert_datish_wrong_format(sym)
    assert_datish_future(sym)
    assert_datish_past(sym)
  end

  def assert_datish_nil(sym)
    @task.send("#{sym}=", nil)
    assert_valid(@task)
  end

  def assert_datish_empty(sym)
    @task.send("#{sym}=", '')
    assert_invalid(@task)
  end

  def assert_datish_wrong_format(sym)
    @task.send("#{sym}=", "foobar")
    assert_invalid(@task)
  end

  def assert_datish_future(sym)
    @task.send("#{sym}=", DateTime.now.advance(:days => 1))
    assert_valid(@task)
  end

  def assert_datish_past(sym)
    @task.send("#{sym}=", DateTime.now.advance(:days => -1))
    assert_valid(@task)
  end

  def test_equality
    a1 = Task.new('foo')
    a2 = Task.new('foo')

    # Tasks are entities, so even with the same attributes, two different objects
    # must not be treated equal
    assert_inequality(a1, a2)
    
    # But comparing the same thing to itself is fine
    assert_equal(a1, a1)
    assert_equal(a2, a2)
  end

  def test_equality_different_description
    a1 = Task.new('foo')
    a2 = Task.new('bar')
    assert_inequality(a1, a2)
  end

  def test_equality_different_entry
    a1 = Task.new('foo')
    a1.entry = DateTime.now

    a2 = Task.new('foo')
    a2.entry = DateTime.now.advance(:days => -1)

    assert_inequality(a1, a2)
  end

  def test_equality_different_description_and_entry
    a1 = Task.new('foo')
    a1.entry = DateTime.now

    a2 = Task.new('bar')
    a2.entry = DateTime.now.advance(:days => -1)

    assert_inequality(a1, a2)
  end
end
