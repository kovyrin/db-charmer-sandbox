require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RangeShardedModel, "class" do
  describe "method set_shard_for" do      
    describe "should correctly set shards in range-defined shards" do
      before(:each) do
        RangeShardedModel.set_default_shard
      end

      [ 0, 1, 50, 99].each do |id|
        it "for #{id}" do
          RangeShardedModel.set_shard_for(id)
          RangeShardedModel.active_shard.should == RangeShardedModel.shards[0...100]
        end
      end

      [ 100, 101, 150, 199].each do |id|
        it "for #{id}" do
          RangeShardedModel.set_shard_for(id)
          RangeShardedModel.active_shard.should == RangeShardedModel.shards[0...100]
        end
      end
    end
    
    describe "should correctly set shards in default shard" do
      before(:each) do
        RangeShardedModel.set_shard_for(1)
      end
      
      [ 200, 201, 500].each do |id|
        it "for #{id}" do
          RangeShardedModel.set_shard_for(id)
          RangeShardedModel.active_shard.should == RangeShardedModel.shards[:default]
        end
      end
    end
    
    it "should raise an exception when there is no default shard and no ranged shards matched" do
      default_shard = RangeShardedModel.shards.delete(:default)
      lambda { RangeShardedModel.shard_for(500) }.should raise_error(ArgumentError)
      RangeShardedModel.shards[:default] = default_shard      
    end
  end
end
