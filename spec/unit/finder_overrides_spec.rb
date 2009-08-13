require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "ActiveRecord slave-enabled models" do
  before do
    class User < ActiveRecord::Base
      db_magic :slave => :slave01
    end
  end

  describe "in finder method" do
    [ :first, :last, :all ].each do |meth|
      describe meth do
        it "should go to the slave if called on the first level connection" do
          User.on_slave.connection.should_receive(:select_all).and_return([])
          User.send(meth)
        end
    
        it "should not change connection if called in an on_db block" do
          User.on_db(:logs).connection.should_receive(:select_all).and_return([])
          User.on_slave.connection.should_not_receive(:select_all)
          User.on_db(:logs).send(meth)
        end

        it "should not change connection when it's already been changed by on_slave call" do
          User.on_slave do
            User.on_slave.connection.should_receive(:select_all).and_return([])
            User.should_not_receive(:on_db)
            User.send(meth)
          end
        end
      end
    end
  end
  
  describe "in calculation method" do
    [ :count, :minimum, :maximum, :average ].each do |meth|
      describe meth do
        it "should go to the slave if called on the first level connection" do
          User.on_slave.connection.should_receive(:select_value).and_return(1)
          User.send(meth, :id).should == 1
        end
  
        it "should not change connection if called in an on_db block" do
          User.on_db(:logs).connection.should_receive(:select_value).and_return(1)
          User.on_slave.connection.should_not_receive(:select_value)
          User.on_db(:logs).send(meth, :id).should == 1
        end

        it "should not change connection when it's already been changed by on_slave call" do
          User.on_slave do
            User.on_slave.connection.should_receive(:select_value).and_return(1)
            User.should_not_receive(:on_db)
            User.send(meth, :id).should == 1
          end
        end
      end
    end
  end
end
