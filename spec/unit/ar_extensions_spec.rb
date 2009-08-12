require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class FooModel < ActiveRecord::Base; end    

describe DbCharmer, "for ActiveRecord models" do
  describe "in establish_real_connection_if_exists method" do
    it "should check connection name if requested" do
      lambda { FooModel.establish_real_connection_if_exists(:foo, true) }.should raise_error(ArgumentError)
    end

    it "should not check connection name if not reqested" do
      lambda { FooModel.establish_real_connection_if_exists(:foo) }.should_not raise_error
    end

    it "should not check connection name if reqested not to" do
      lambda { FooModel.establish_real_connection_if_exists(:foo, false) }.should_not raise_error
    end
    
    it "should establish connection when connection configuration exists" do
      FooModel.should_receive(:establish_connection)
      FooModel.establish_real_connection_if_exists(:logs)
    end
  end
  
  describe "in db_charmer_connection_proxy methods" do
    before do
      FooModel.db_charmer_connection_proxy = nil
    end
    
    it "should implement both accessor methods" do
      proxy = mock('connection proxy')
      FooModel.db_charmer_connection_proxy = proxy
      FooModel.db_charmer_connection_proxy.should be(proxy)
    end
  end

  describe "in db_charmer_slaves methods" do
    it "should return [] if no slaves set for a model" do
      FooModel.db_charmer_slaves = nil
      FooModel.db_charmer_slaves.should == []
    end
    
    it "should implement both accessor methods" do
      proxy = mock('connection proxy')
      FooModel.db_charmer_slaves = [ proxy ]
      FooModel.db_charmer_slaves.should == [ proxy ]
    end
  end
  
  describe "in connection method" do
    it "should return AR's original connection if no connection proxy is set" do
      FooModel.connection.should be_kind_of(ActiveRecord::ConnectionAdapters::AbstractAdapter)
    end

    it "should not return connection proxy value if the proxy is set until connection is hijacked" do
      proxy = mock('connection proxy')
      FooModel.db_charmer_connection_proxy = proxy
      FooModel.connection.should_not be(proxy)
      FooModel.hijack_connection!
      FooModel.connection.should be(proxy)
    end
  end
end
