require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "DbCharmer::Sharding" do
  describe "in register_connection method" do
    it "should raise an exception if passed config has no :name option" do
      lambda {
        DbCharmer::Sharding.register_connection(:method => :range, :ranges => { :default => :foo })
      }.should raise_error(ArgumentError)
    end
  end

  describe "in sharded_connection method" do
    it "should raise an error for invalid connection names" do
      lambda { DbCharmer::Sharding.sharded_connection(:blah) }.should raise_error(ArgumentError)
    end
  end
end

