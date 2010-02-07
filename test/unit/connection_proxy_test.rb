require 'test_helper'

class ConnectionProxyTest < ActiveSupport::TestCase
  class Foo; end

  def setup
    @conn = mock('connection')
    @proxy = DbCharmer::ConnectionProxy.new(Foo)
  end
  
  test "ConnectionProxy should retrieve connection from an underlying class" do
    Foo.expects(:retrieve_connection).returns(@conn)
    @proxy.inspect
  end

  test "ConnectionProxy should be a blankslate for the connection" do
    Foo.stubs(:retrieve_connection).returns(@conn)
    assert_equal(@proxy, @conn)
  end

  test "ConnectionProxy should proxy methods with a block parameter" do
    module MockConnection
      def self.foo
        raise "No block given!" unless block_given?
        yield
      end
    end

    Foo.stubs(:retrieve_connection).returns(MockConnection)
    res = @proxy.foo { :foo }
    assert_equal(res, :foo)
  end
  
  test "ConnectionProxy should proxy all calls to the underlying class connections" do
    Foo.stubs(:retrieve_connection).returns(@conn)
    @conn.expects(:foo)
    @proxy.foo
  end
end
