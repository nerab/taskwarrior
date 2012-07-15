require 'test_helper'

class TestFindTasksByTag < MiniTest::Unit::TestCase
  include TaskWarrior
  include TaskWarrior::Test::Fixtures

  def test_tagged_with
    Commands::Import.new(File.new(fixture('party_taxes.json'))).run
    tagged = MultiJson.load(Commands::FindTasksByTag.new('mall').run)

    assert_equal(3, tagged.size)
    assert_equal(3, tagged.count{|t| t['tags'].include?('mall')})
    assert_equal(1, tagged.count{|t| t['tags'].include?('finance')})
  end
end
