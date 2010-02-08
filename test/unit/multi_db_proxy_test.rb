require 'test_helper'

class MultiDbProxyTest < ActiveSupport::TestCase
  class Blah < ActiveRecord::Base
    set_table_name :posts
  end

  def setup
    Blah.db_magic(:connection => nil)
    @blah = Blah.new    
  end

  #------------------------------------------------------------------------------------------------------------------------------------

  test "AR model instance with db_magic in on_db method with a block should switch connection to specified one and yield the block" do
    assert_nil Blah.db_charmer_connection_proxy
    @blah.on_db(:logs) do
      assert_not_nil Blah.db_charmer_connection_proxy
    end
  end

  test "AR model instance with db_magic in on_db method with a block should switch connection back after the block finished its work" do
    assert_nil Blah.db_charmer_connection_proxy
    @blah.on_db(:logs) {}
    assert_nil Blah.db_charmer_connection_proxy
  end

  test "AR model instance with db_magic in on_db method with a block should manage connection level values" do
    assert_equal(Blah.db_charmer_connection_level, 0)
    @blah.on_db(:logs) do |m|
      assert_equal(m.class.db_charmer_connection_level, 1)
    end
    assert_equal(Blah.db_charmer_connection_level, 0)
  end
  
  #------------------------------------------------------------------------------------------------------------------------------------
  
  test "AR model instance with db_magic in on_db method as a chain call should switch connection for all chained calls" do
    assert_nil Blah.db_charmer_connection_proxy
    assert_not_nil @blah.on_db(:logs)
  end

  test "AR model instance with db_magic in on_db method as a chain call should switch connection for non-chained calls" do
    assert_nil Blah.db_charmer_connection_proxy
    @blah.on_db(:logs).to_s
    assert_nil Blah.db_charmer_connection_proxy
  end

  #------------------------------------------------------------------------------------------------------------------------------------

  test "AR model class in on_db method with a block should switch connection to specified one and yield the block" do
    assert_nil Blah.db_charmer_connection_proxy
    Blah.on_db(:logs) do
      assert_not_nil Blah.db_charmer_connection_proxy
    end
  end

  test "AR model class in on_db method with a block should switch connection back after the block finished its work" do
    assert_nil Blah.db_charmer_connection_proxy
    Blah.on_db(:logs) {}
    assert_nil Blah.db_charmer_connection_proxy
  end

  test "AR model class in on_db method with a block should manage connection level values" do
    assert_equal(Blah.db_charmer_connection_level, 0)
    Blah.on_db(:logs) do |m|
      assert_equal(Blah.db_charmer_connection_level, 1)
    end
    assert_equal(Blah.db_charmer_connection_level, 0)
  end

  #------------------------------------------------------------------------------------------------------------------------------------

  test "AR model class in on_db method as a chain call should switch connection for all chained calls" do
    assert_nil Blah.db_charmer_connection_proxy
    assert_not_nil Blah.on_db(:logs)
  end

  test "AR model class in on_db method as a chain call should switch connection for non-chained calls" do
    assert_nil Blah.db_charmer_connection_proxy
    Blah.on_db(:logs).to_s
    assert_nil Blah.db_charmer_connection_proxy
  end

  #------------------------------------------------------------------------------------------------------------------------------------

  test "AR model class in on_slave method should use one tof the model's slaves if no slave given" do
    Blah.db_magic :slaves => [ :slave01 ]
    assert_equal(Blah.on_slave.db_charmer_connection_proxy.object_id, Blah.coerce_to_connection_proxy(:slave01).object_id)
  end

  test "AR model class in on_slave method should use given slave" do
    Blah.db_magic :slaves => [ :slave01 ]
    assert_equal(Blah.on_slave(:logs).db_charmer_connection_proxy.object_id, Blah.coerce_to_connection_proxy(:logs).object_id)
  end

  test "AR model class in on_slave method should support block calls" do
    Blah.db_magic :slaves => [ :slave01 ]
    Blah.on_slave do |m|
      assert_equal(m.db_charmer_connection_proxy.object_id, Blah.coerce_to_connection_proxy(:slave01).object_id)
    end
  end

  #------------------------------------------------------------------------------------------------------------------------------------

  test "AR model class in on_master method should run queries on the master" do
    Blah.db_magic :slaves => [ :slave01 ]
    assert_nil Blah.on_master.db_charmer_connection_proxy
  end   
end
