require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ShardedModel, "class" do
  it "should respond to active_sahrd with the name of the active shard" do
    ShardedModel.should respond_to(:active_shard)
    ShardedModel.active_shard.should be_kind_of(Symbol)
  end
  
  it "should respond to shards and return a hash of shards defined for the class" do
    ShardedModel.should respond_to(:shards)
    ShardedModel.shards.should be_kind_of(Hash)    
  end
end
