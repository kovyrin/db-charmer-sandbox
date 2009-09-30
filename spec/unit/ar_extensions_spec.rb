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

  describe "in db_charmer_opts methods" do
    before do
      FooModel.db_charmer_opts = nil
    end
    
    it "should implement both accessor methods" do
      opts = { :foo => :bar}
      FooModel.db_charmer_opts = opts
      FooModel.db_charmer_opts.should be(opts)
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
    
    it "should implement random slave selection" do
      FooModel.db_charmer_slaves = [ :proxy1, :proxy2, :proxy3 ]
      srand(0)
      FooModel.db_charmer_random_slave.should == :proxy1
      FooModel.db_charmer_random_slave.should == :proxy2
      FooModel.db_charmer_random_slave.should == :proxy1
      FooModel.db_charmer_random_slave.should == :proxy2
      FooModel.db_charmer_random_slave.should == :proxy2
      FooModel.db_charmer_random_slave.should == :proxy3
    end
  end

  describe "in db_charmer_connection_levels methods" do
    it "should return 0 by default" do
      FooModel.db_charmer_connection_level = nil
      FooModel.db_charmer_connection_level.should == 0
    end
    
    it "should implement both accessor methods and support inc/dec operations" do
      FooModel.db_charmer_connection_level = 1
      FooModel.db_charmer_connection_level.should == 1
      FooModel.db_charmer_connection_level += 1
      FooModel.db_charmer_connection_level.should == 2
      FooModel.db_charmer_connection_level -= 1
      FooModel.db_charmer_connection_level.should == 1
    end
    
    it "should implement db_charmer_top_level_connection? method" do
      FooModel.db_charmer_connection_level = 1
      FooModel.should_not be_db_charmer_top_level_connection
      FooModel.db_charmer_connection_level = 0
      FooModel.should be_db_charmer_top_level_connection
    end
  end
  
  describe "in connection method" do
    it "should return AR's original connection if no connection proxy is set" do
      FooModel.db_charmer_connection_proxy = nil
      FooModel.connection.should be_kind_of(ActiveRecord::ConnectionAdapters::AbstractAdapter)
    end

    it "should not return connection proxy value if the proxy is set until connection is hijacked" do
      class FooModel2 < ActiveRecord::Base; end
      proxy = mock('connection proxy')
      FooModel2.db_charmer_connection_proxy = proxy
      FooModel2.connection.should_not be(proxy)
      FooModel2.hijack_connection!
      FooModel2.connection.should be(proxy)
    end
  end
end
