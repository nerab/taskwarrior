require 'test_helper'

class TestRepositoryLoad < Test::Unit::TestCase
  include TaskWarrior
  include TaskWarrior::Test::Fixtures

  def test_empty
    assert_equal(0, TaskWarrior.tasks.size)
    assert_equal(0, TaskWarrior.projects.size)
    assert_equal(0, TaskWarrior.tags.size)
  end

  def test_different_projects_tags
    Commands::Import.new(File.new(fixture('party_taxes.json'))).run
    assert_equal(8, TaskWarrior.tasks.size)
    assert_equal(1, TaskWarrior.projects.size)
  skip("Re-enable with TagRepository implemented")
    assert_equal(2, TaskWarrior.tags.size)
  end

  def test_different_projects_tags_no_deps
    Commands::Import.new(File.new(fixture('no_deps.json'))).run
    assert_equal(6, TaskWarrior.tasks.size)
    assert_equal(1, TaskWarrior.projects.size)
  skip("Re-enable with TagRepository implemented")
    assert_equal(1, TaskWarrior.tags.size)
  end
end
