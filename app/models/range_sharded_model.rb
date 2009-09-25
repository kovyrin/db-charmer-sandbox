class RangeShardedModel < ActiveRecord::Base
  SHARDING_RANGES = {
    0...100   => :shard1,
    100..200  => :shard2,
    :default  => :shard3
  }
  
  db_magic :sharded => {
    :key => :id,
    :method => :range,
    :ranges => SHARDING_RANGES
  }
end
