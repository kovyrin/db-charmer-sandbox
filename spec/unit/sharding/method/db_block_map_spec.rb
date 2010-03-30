require 'spec/spec_helper'

describe DbCharmer::Sharding::Method::DbBlockMap do
  fixtures :event_shards_info, :event_shards_map

  before(:each) do
    @sharder = DbCharmer::Sharding::Method::DbBlockMap.new(
      :name => :social,
      :block_size => 10,
      :map_table => :event_shards_map,
      :shards_table => :event_shards_info,
      :connection => :social_shard_info
    )
    @conn = DbCharmer::ConnectionFactory.connect(:social_shard_info)
  end

  describe "standard interface" do
    it "should respond to shard_for_id" do
      @sharder.should respond_to(:shard_for_key)
    end

    it "should return a shard config to be used for a key" do
      @sharder.shard_for_key(1).should be_kind_of(Hash)
    end

    it "should have shard_connections method and return a list of db connections" do
      @sharder.shard_connections.should_not be_empty
    end
  end

  it "should correctly return shards for all blocks defined in the mapping table" do
    blocks = @conn.select_all("SELECT * FROM event_shards_map")

    blocks.each do |blk|
      shard = @sharder.shard_for_key(blk['start_id'])
      shard[:name].should match(/social.*#{blk['shard_id']}$/)

      shard = @sharder.shard_for_key(blk['start_id'].to_i + 1)
      shard[:name].should match(/social.*#{blk['shard_id']}$/)

      shard = @sharder.shard_for_key(blk['end_id'].to_i - 1)
      shard[:name].should match(/social.*#{blk['shard_id']}$/)
    end
  end

  describe "for non-existing blocks" do
    before do
      @max_id = @conn.select_value("SELECT max(end_id) FROM event_shards_map").to_i
    end

    it "should not fail" do
      lambda {
         @sharder.shard_for_key(@max_id + 1)
      }.should_not raise_error
    end

    it "should create a new one" do
      @sharder.shard_for_key(@max_id + 1).should_not be_nil
    end

    it "should assign it to the least loaded shard" do
      @sharder.shard_for_key(@max_id + 1)[:name].should match(/shard.*03$/)
    end

    it "should not condider non-open shards" do
      @conn.execute("UPDATE event_shards_info SET open = 0 WHERE id = 3")
      @sharder.shard_for_key(@max_id + 1)[:name].should_not match(/shard.*03$/)
    end

    it "should not condider disabled shards" do
      @conn.execute("UPDATE event_shards_info SET enabled = 0 WHERE id = 3")
      @sharder.shard_for_key(@max_id + 1)[:name].should_not match(/shard.*03$/)
    end
  end

  it "should fail on invalid shard references" do
     @conn.execute("DELETE FROM event_shards_info")
     lambda { @sharder.shard_for_key(1) }.should raise_error(ArgumentError)
  end
end
