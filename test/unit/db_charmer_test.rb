require 'test_helper'

class DbCharmerTest < ActiveSupport::TestCase
  test "DbCharmer should have connections_should_exist accessors" do
#    assert_not_nil DbCharmer.connections_should_exist
    DbCharmer.connections_should_exist = :foo
    assert_equal(DbCharmer.connections_should_exist, :foo)
  end

  test "DbCharmer should have connections_should_exist? method" do
    DbCharmer.connections_should_exist = true
    assert_true DbCharmer.connections_should_exist?
    DbCharmer.connections_should_exist = false
    assert_false DbCharmer.connections_should_exist?
    DbCharmer.connections_should_exist = "shit"
    assert_true DbCharmer.connections_should_exist?
    DbCharmer.connections_should_exist = nil
    assert_false DbCharmer.connections_should_exist?
  end

  test "DbCharmer should have migration_connections_should_exist accessors" do
#    assert_not_nil DbCharmer.migration_connections_should_exist
    DbCharmer.migration_connections_should_exist = :foo
    assert_equal(DbCharmer.migration_connections_should_exist, :foo)
  end

  test "DbCharmer should have migration_connections_should_exist? method" do
    DbCharmer.migration_connections_should_exist = true
    assert_true DbCharmer.migration_connections_should_exist?
    DbCharmer.migration_connections_should_exist = false
    assert_false DbCharmer.migration_connections_should_exist?
    DbCharmer.migration_connections_should_exist = "shit"
    assert_true DbCharmer.migration_connections_should_exist?
    DbCharmer.migration_connections_should_exist = nil
    assert_false DbCharmer.migration_connections_should_exist?
  end
end