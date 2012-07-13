require 'test_helper'

class TestProjectRepository < Test::Unit::TestCase
  include TaskWarrior
  include TaskWarrior::Test::Fixtures

  def setup
    super

    @projects = ProjectRepository.new
    assert_equal(0, @repo.all.size)
    cmd = Commands::Import.new(File.new(fixture('party_taxes.json')))
    cmd.run
    assert_equal(8, @repo.all.size)
  end

  def test_projects
    party = @projects['party']
    assert_not_nil(party)
    assert_equal(6, party.tasks.size)
  end

  def test_equality
    t1 = @repo['b587f364-c68e-4438-b4d6-f2af6ad62518']
    t2 = t1.dup
    assert_not_equal(t1.object_id, t2.object_id)

    t1.description = 'changed'
    assert_equal(t1, t2)
    assert(!(t1.eql?(t2)))
  end
end
