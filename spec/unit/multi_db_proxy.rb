require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "ActiveRecord model with db_magic" do
  before do
    class Blah < ActiveRecord::Base
      db_magic :connection => nil
    end
  end
  
  describe "in on_db method" do
    describe "with a block" do
      it "should switch connection to specified one and yield the block" do
        Blah.db_charmer_connection_proxy.should be_nil
        Blah.on_db(:logs) do
          Blah.db_charmer_connection_proxy.should_not be_nil
        end
      end
      
      it "should switch connection back after the block finished its work" do
        Blah.db_charmer_connection_proxy.should be_nil
        Blah.on_db(:logs) {}
        Blah.db_charmer_connection_proxy.should be_nil
      end
    end
    
    describe "as a chain call" do
      it "should switch connection for all chained calls" do
        Blah.db_charmer_connection_proxy.should be_nil
        Blah.on_db(:logs).should_not be_nil
      end
      
      it "should switch connection for non-chained calls" do
        Blah.db_charmer_connection_proxy.should be_nil
        Blah.on_db(:logs).to_s
        Blah.db_charmer_connection_proxy.should be_nil
      end
    end
  end
end
