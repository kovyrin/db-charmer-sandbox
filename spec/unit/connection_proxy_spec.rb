require 'spec_helper'

describe DbCharmer::ConnectionProxy do
  before(:each) do
    class Foo; end
    @conn = mock('connection')
    @proxy = DbCharmer::ConnectionProxy.new(Foo, :foo)
  end

  it "should retrieve connection from an underlying class" do
    Foo.should_receive(:retrieve_connection).and_return(@conn)
    @proxy.inspect
  end

  it "should be a blankslate for the connection" do
    Foo.stub!(:retrieve_connection).and_return(@conn)
    @proxy.should be(@conn)
  end

  it "should proxy methods with a block parameter" do
    module MockConnection
      def self.foo
        raise "No block given!" unless block_given?
        yield
      end
    end
    Foo.stub!(:retrieve_connection).and_return(MockConnection)
    res = @proxy.foo { :foo }
    res.should == :foo
  end

  it "should proxy all calls to the underlying class connections" do
    Foo.stub!(:retrieve_connection).and_return(@conn)
    @conn.should_receive(:foo)
    @proxy.foo
  end
end
