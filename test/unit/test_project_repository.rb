require 'test_helper'

class TestProjectRepository < MiniTest::Unit::TestCase
  include TaskWarrior
  include TaskWarrior::Test::Fixtures

  def setup
    super

    @projects = ProjectRepository.new
    assert_equal(0, @projects.all.size)
    cmd = Commands::Import.new(File.new(fixture('party_taxes.json')))
    cmd.run
    assert_equal(1, @projects.all.size)
  end

  def test_projects
    party = @projects.find('party').first
    refute_nil(party)
    assert_equal(6, party.tasks.size)
  end

  def test_tags_of_project
    party = @projects.find('party').first
    refute_nil(party)
    assert_equal(2, party.tasks.count{|t| t.tags})
  end

  def test_equality
    t1 = @projects.find('party').first
    t2 = t1.dup
    refute_equal(t1.object_id, t2.object_id)

  skip('Re-enable once projects support write operations (see Task)')
    t1.name = 'less_taxes'
    assert_equal(t1, t2)
    assert(!(t1.eql?(t2)))
  end
end
