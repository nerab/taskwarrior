require 'test_helper'

class TestTagRepository < MiniTest::Unit::TestCase
  include TaskWarrior
  include TaskWarrior::Test::Fixtures

  def setup
    super

    @tags = TagRepository.new
    assert_equal(4, @tags.size) # next, nocal, nocolor, nonag are there OOTB
    cmd = Commands::Import.new(File.new(fixture('party_taxes.json')))
    cmd.run
    assert_equal(6, @tags.size)
  end

  def test_tags
    tags = @tags.all
    refute_nil(tags)
    assert_equal(6, tags.size)

    assert(tags.include?(@tags['finance']))
    assert(tags.include?(@tags['mall']))
  end

  def test_tasks_of_tag_finance
    finance = @tags['finance']
    refute_nil(finance)
    assert_equal(2, finance.tasks.size)
  end

  def test_tasks_of_tag_mall
    mall = @tags['mall']
    refute_nil(mall)
    assert_equal(2, mall.tasks.size)
  end

  def test_projects_of_tag
    mall = @tags['mall']
    refute_nil(mall)
    assert_equal(2, mall.tasks.count{|t| t.project})

    # {
    #   "uuid":"e5a867b7-0116-457d-ba43-9ac2bee6ad2a",
    #   "description":"Design invitations",
    #   "project":"party",
    #   "tags":["mall"]
    # },#

    # {
    #   "uuid":"9f6f3738-1c08-4f45-8eb4-1e90864c7588",
    #   "description":"Print invitations",
    #   "project":"party",
    #   "tags":["mall"],
    # }
  end

  def test_equality
    t1 = @tags['mall']
    t2 = t1.dup
    refute_equal(t1.object_id, t2.object_id)

  skip('Re-enable once projects support write operations (see Task)')
    t1.name = 'shopping'
    assert_equal(t1, t2)
    assert(!(t1.eql?(t2)))
  end
end
