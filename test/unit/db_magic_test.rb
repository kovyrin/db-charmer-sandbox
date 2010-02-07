require 'test_helper'

class DbMagicTest < ActiveSupport::TestCase
  class Blah < ActiveRecord::Base; end

  test "In AR models db_magic method with :connection param should change model's connection to specified one" do
    Blah.db_magic :connection => :logs
    assert_equal(Blah.connection.object_id, DbCharmer::ConnectionFactory.connect(:logs).object_id)
  end

  test "In AR models db_magic method with :connection param should pass :should_exist paramater value to the underlying connection logic" do
    DbCharmer::ConnectionFactory.expects(:connect).with(:logs, 'blah')
    Blah.db_magic :connection => :logs, :should_exist => 'blah'
  end

   test "In AR models db_magic method with :connection param should use global DbMagic's connections_should_exist attribute if no :should_exist passed" do
    DbCharmer.connections_should_exist = true
    DbCharmer::ConnectionFactory.expects(:connect).with(:logs, true)
    Blah.db_magic :connection => :logs, :should_exist => false
  end

  #-------------------------------------------------------------------------------------------------------

  test "In AR models db_magic method with :slave or :slaves param should merge :slave and :slaves values" do
    Blah.db_charmer_slaves = []
    assert_equal(Blah.db_charmer_slaves, [])

    Blah.db_magic :slave => :slave01
    assert_equal(Blah.db_charmer_slaves.size, 1)

    Blah.db_magic :slaves => [ :slave01 ]
    assert_equal(Blah.db_charmer_slaves.size, 1)

    Blah.db_magic :slaves => [ :slave01 ], :slave => :logs
    assert_equal(Blah.db_charmer_slaves.size, 2)
  end

  test "In AR models db_magic method with :slave or :slaves param should set up a hook to propagate db_magic params to all the children models" do
    class ParentFoo < ActiveRecord::Base
      db_magic :foo => :bar
    end
    class ChildFoo < ParentFoo; end

    assert_equal(ChildFoo.db_charmer_opts, ParentFoo.db_charmer_opts)
  end
end
