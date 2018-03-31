# frozen_string_literal: true

require 'test_helper'

class TestRepository < MiniTest::Test
  include TaskWarrior
  include TaskWarrior::Test::Fixtures

  def setup
    @repo = Repository.new(File.read(fixture('party_taxes.json')))
  end

  def test_tags_of_task
    atm = @repo['67aafe0b-ddd7-482b-9cfa-ac42c43e7559']
    refute_nil(atm)
    assert_equal(2, atm.tags.size)
  end

  def test_all
    assert_equal(8, @repo.tasks.size)

    one = @repo['6fd0ba4a-ab67-49cd-ac69-64aa999aff8a']
    assert_equal('Select a free weekend in November', one.description)
    assert_equal(:high, one.priority)
    assert_equal('party', one.project.name)
    assert_equal(:pending, one.status)

    assert_equal(1, one.annotations.size)
    assert_equal(DateTime.parse('20120629T191534Z'), one.annotations.first.entry)
    assert_equal('the 13th looks good', one.annotations.first.description)
  end

  def test_child
    assert_equal(1, @repo['b587f364-c68e-4438-b4d6-f2af6ad62518'].children.size)
  end

  def test_parent
    assert_equal(@repo['b587f364-c68e-4438-b4d6-f2af6ad62518'], @repo['99c9e1bb-ed75-4525-b05d-cf153a7ee1a1'].parent)
  end

  def test_projects
    party = @repo.project('party')
    refute_nil(party)
    assert_equal(6, party.tasks.size)
  end

  def test_tags
    tags = @repo.tags
    refute_nil(tags)
    assert_equal(2, tags.size)
    assert(tags.include?(@repo.tag('finance')))
    assert(tags.include?(@repo.tag('mall')))
  end

  def test_tasks_of_tag_finance
    finance = @repo.tag('finance')
    refute_nil(finance)
    assert_equal(2, finance.tasks.size)
  end

  def test_tasks_of_tag_mall
    mall = @repo.tag('mall')
    refute_nil(mall)
    assert_equal(3, mall.tasks.size)
  end

  def test_equality
    t1 = @repo['b587f364-c68e-4438-b4d6-f2af6ad62518']
    t2 = t1.dup
    refute_equal(t1.object_id, t2.object_id)

    t1.description = 'changed'
    assert_equal(t1, t2)
    assert(!t1.eql?(t2))
  end
end
