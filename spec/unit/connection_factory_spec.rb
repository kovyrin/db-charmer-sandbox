require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DbCharmer::ConnectionFactory do
  describe "in generate_abstract_class method" do
    it "should not fail if requested connection config does not exists" do
      lambda { DbCharmer::ConnectionFactory.generate_abstract_class('foo') }.should_not raise_error
    end

    it "should not fail if requested connection config does not exists and should_exist = false" do
      lambda { DbCharmer::ConnectionFactory.generate_abstract_class('foo', false) }.should_not raise_error
    end

    it "should fail if requested connection config does not exists and should_exist = true" do
      lambda { DbCharmer::ConnectionFactory.generate_abstract_class('foo', true) }.should raise_error(ArgumentError)
    end

    it "should generate abstract connection classes" do
      klass = DbCharmer::ConnectionFactory.generate_abstract_class('foo')
      klass.superclass.should be(ActiveRecord::Base)
    end
  end
  
  describe "in establish_connection method" do
    it "should generate an abstract class" do
      klass = mock('AbstractClass')
      conn = mock('connection')
      klass.stub!(:retrieve_connection).and_return(conn)
      DbCharmer::ConnectionFactory.should_receive(:generate_abstract_class).and_return(klass)
      DbCharmer::ConnectionFactory.establish_connection(:foo).should be(conn)
    end

    it "should create and return a connection proxy for the abstract class" do
      klass = mock('AbstractClass')
      DbCharmer::ConnectionFactory.should_receive(:generate_abstract_class).and_return(klass)
      DbCharmer::ConnectionProxy.should_receive(:new).with(klass)
      DbCharmer::ConnectionFactory.establish_connection(:foo)
    end
  end
  
  describe "in connect method" do
    it "should return a connection proxy" do
      DbCharmer::ConnectionFactory.connect(:logs).should be_kind_of(ActiveRecord::ConnectionAdapters::AbstractAdapter)
    end
    
    it "should memoize proxies" do
      conn = mock('connection')
      DbCharmer::ConnectionFactory.should_receive(:establish_connection).with('foo', false).once.and_return(conn)
      DbCharmer::ConnectionFactory.connect(:foo)
      DbCharmer::ConnectionFactory.connect(:foo)
    end
  end
end
