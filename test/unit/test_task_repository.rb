require 'test_helper'

class TestTaskRepository < Test::Unit::TestCase
  include TaskWarrior
  include TaskWarrior::Test::Fixtures

  def setup
    super

    @tasks = TaskRepository.new
    assert_equal(0, @tasks.all.size)
    Commands::Import.new(File.new(fixture('party_taxes.json'))).run
    assert_equal(8, @tasks.all.size)
  end

  def test_tags_of_task
    atm = @tasks['67aafe0b-ddd7-482b-9cfa-ac42c43e7559']
    assert_not_nil(atm)
    assert_equal(2, atm.tags.size)
  end

  def test_properties
    one = @tasks['6fd0ba4a-ab67-49cd-ac69-64aa999aff8a']
    assert_equal('Select a free weekend in November', one.description)
    assert_equal(:high, one.priority)
    assert_equal('party', one.project.name)
    assert_equal(:pending, one.status)

    assert_equal(1, one.annotations.size)
    assert_equal(DateTime.parse('20120629T191534Z'), one.annotations.first.entry)
    assert_equal('the 13th looks good', one.annotations.first.description)
  end

  def test_child
    skip('TBD')
    assert_equal(1, @tasks['b587f364-c68e-4438-b4d6-f2af6ad62518'].children.size)
  end

  def test_parent
    assert_equal(@tasks['b587f364-c68e-4438-b4d6-f2af6ad62518'], @tasks['99c9e1bb-ed75-4525-b05d-cf153a7ee1a1'].parent)
  end

  def test_equality
    t1 = @tasks['b587f364-c68e-4438-b4d6-f2af6ad62518']
    t2 = t1.dup
    assert_not_equal(t1.object_id, t2.object_id)

    t1.description = 'changed'
    assert_equal(t1, t2)
    assert(!(t1.eql?(t2)))
  end

  def test_save_plain
    old_size = @tasks.all.size
    task = Task.new('foo equals bar')
    @tasks.save(task)
    assert_equal(old_size + 1, @tasks.all.size)
  end

  def test_find_by_project
    one = @tasks['6fd0ba4a-ab67-49cd-ac69-64aa999aff8a']
    party = one.project
    party_tasks = @tasks.find_by_project(party)
    assert_equal(6, party_tasks.size)
    assert_equal(6, party.tasks.size)

    party_tasks.each do |task|
      assert_equal(party.tasks, task.project.tasks)
      assert_equal(party.name, task.project.name)
      assert_equal(party, task.project)
    end
  end
end
