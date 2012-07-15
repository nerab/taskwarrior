require 'test_helper'

class TestTagRepository < MiniTest::Unit::TestCase
  include TaskWarrior
  include TaskWarrior::Test::Fixtures

  def setup
    skip "Not done yet"
    super

    @tags = TagRepository.new
    assert_equal(0, @tags.all.size)
    cmd = Commands::Import.new(File.new(fixture('party_taxes.json')))
    cmd.run
    assert_equal(8, @tags.all.size)
  end

  def test_tags
    tags = @tags.all
    refute_nil(tags)
    assert_equal(2, tags.size)
    assert(tags.include?(@tags.tag('finance')))
    assert(tags.include?(@tags.tag('mall')))
  end

  def test_tasks_of_tag_finance
    finance = @tags.tag('finance')
    refute_nil(finance)
    assert_equal(2, finance.tasks.size)
  end

  def test_tasks_of_tag_mall
    mall = @tags.tag('mall')
    refute_nil(mall)
    assert_equal(3, mall.tasks.size)
  end

  def test_equality
    t1 = @tags['b587f364-c68e-4438-b4d6-f2af6ad62518']
    t2 = t1.dup
    refute_equal(t1.object_id, t2.object_id)

    t1.description = 'changed'
    assert_equal(t1, t2)
    assert(!(t1.eql?(t2)))
  end
end
